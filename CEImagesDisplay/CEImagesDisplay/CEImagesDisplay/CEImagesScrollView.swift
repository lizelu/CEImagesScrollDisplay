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
            
            let imageView = UIImageView.init(frame: CGRectMake(0, 0, self.width, self.height))
            imageView.contentMode = .ScaleAspectFill
            imageView.image = UIImage.init(named: self.imagesNameArray[i])
            
            let tempButton: UIButton = UIButton.init(frame: getButtonFrameWithIndex(i))
            tempButton.addTarget(self, action: #selector(tapButton), forControlEvents: .TouchUpInside)
            
            tempButton.tag = i
            tempButton.clipsToBounds = true
            tempButton.addSubview(imageView)
            self.addSubview(tempButton)
        }
    }
    
//    private func moveButtons() {
//        for i in 0..<self.buttonsArray.count {
//            let button: UIButton = self.buttonsArray[i]
//            
//            
//        }
//    }
    
    private func getButtonFrameWithIndex(index: Int) -> CGRect{
        return CGRectMake(CGFloat(index) * self.width, 0, self.width, self.height)
    }
    
    @objc private func tapButton(sender: UIButton) {
        print("点击按钮\(sender.tag)")
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
