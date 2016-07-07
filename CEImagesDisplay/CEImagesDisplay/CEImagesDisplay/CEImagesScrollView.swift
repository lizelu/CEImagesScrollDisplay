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
    
    var buttonsArray: Array<CEImageViewButton> = []
    var imagesNameArray: Array<String> = []
    var currentPage: Int = 0
    var buttonContentView: UIView!
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initImagesNameArray()
        self.configScrollView()
        self.initButtonContentView()
        self.initButtons()
    }
    
    private func configScrollView() {
        self.bounces = false
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
    
    private func initButtonContentView() {
        let frame = CGRectMake(0, 0, self.width * 3, self.height)
        self.buttonContentView = UIView(frame: frame)
        self.addSubview(self.buttonContentView)
    }
    
    private func initButtons() {
        
        for i in 0..<3 {
            let tempButton: CEImageViewButton = CEImageViewButton.init(frame: getButtonFrameWithIndex(i))
            tempButton.tag = i
            self.buttonContentView.addSubview(tempButton)
            self.buttonsArray.append(tempButton)
            
            tempButton.setButtonTouchUpInsideClosure({ (sender) in
                print(self.currentPage)
            })
        }
        
        self.setButtonImage(self.currentPage)
    }
    
    private func setButtonImage(currentPage: Int) {
        
        let imageIndexArray = [getBeforeImageIndex(currentPage),
                               getCurrentImageIndex(currentPage),
                               getLastImageIndex(currentPage)]
        
        for i in 0..<self.buttonsArray.count {
            let tempButton = self.buttonsArray[i]
            let imageName = self.imagesNameArray[imageIndexArray[i]]
            tempButton.buttonImageView.image = UIImage.init(named: imageName)
        }
    }
    
    
    /**
     将所有Button的ImageView都设置成当前显示图片，便于移动
     
     - parameter currentPage: 当前page
     */
    private func setButtonSameImage(currentPage: Int) {
        for i in 0..<self.buttonsArray.count {
            let tempButton = self.buttonsArray[i]
            let currentImageName = self.imagesNameArray[getCurrentImageIndex(currentPage)]
            tempButton.buttonImageView.image = UIImage.init(named: currentImageName)
        }
    }
    
    
    //获取相应按钮上图片的索引
    private func getCurrentImageIndex(currentPage: Int) -> Int {
        let tempCurrentPage = currentPage % self.imagesNameArray.count
        return tempCurrentPage < 0 ? self.imagesNameArray.count - 1 : tempCurrentPage
    }
    
    private func getBeforeImageIndex(currentPage: Int) -> Int {
        let beforeNumber = getCurrentImageIndex(currentPage) - 1
        return beforeNumber < 0 ? self.imagesNameArray.count - 1 : beforeNumber
    }
    
    private func getLastImageIndex(currentPage: Int) -> Int {
        let lastNumber = getCurrentImageIndex(currentPage) + 1
        return lastNumber >= self.imagesNameArray.count ? 0 : lastNumber
    }
    
    
    private func getButtonFrameWithIndex(index: Int) -> CGRect{
        return CGRectMake(CGFloat(index) * self.width, 0, self.width, self.height)
    }
    
    

   
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let temp = scrollView.contentOffset.x / self.width
        
        if temp == 0 || temp == 1 || temp == 2 {
            let direction: Int = Int(temp) - 1
            self.currentPage = getCurrentImageIndex(self.currentPage + direction)
            self.setButtonSameImage(self.currentPage)
            self.contentOffset.x = self.width
            self.setButtonImage(self.currentPage)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
