//
//  CEImagesScrollView.swift
//  CEImagesDisplay
//
//  Created by Mr.LuDashi on 16/7/6.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

import UIKit

class CEImagesScrollView: UIScrollView, UIScrollViewDelegate {
    
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
    }
    
    var buttonsArray: Array<UIButton> = []
    var imagesNameArray: Array<String> = []
    var currentPage: UInt = 0
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configScrollView()
        self.initImagesNameArray()
        self.initButtons()
    }
    
    private func configScrollView() {
        self.delegate = self
        self.backgroundColor = UIColor.grayColor()
        self.contentSize = CGSizeMake(3 * self.width, self.height)
        self.pagingEnabled = true
        self.contentOffset.x = self.width
    }
    
    private func initImagesNameArray() {
        for i in 0...9 {
            self.imagesNameArray.append("00\(i).jpg")
        }
    }
    
    private func initButtons() {
        
        for i in 0..<3 {
            let tempButton: CEImageViewButton = CEImageViewButton.init(frame: getButtonFrameWithIndex(i))
            tempButton.buttonImageView.image = UIImage.init(named: self.imagesNameArray[i])
            
            self.addSubview(tempButton)
            tempButton.setButtonTouchUpInsideClosure({ (sender) in
                print(sender.tag)
            })

        }
    }
    
    
    private func getButtonFrameWithIndex(index: Int) -> CGRect{
        return CGRectMake(CGFloat(index) * self.width, 0, self.width, self.height)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
