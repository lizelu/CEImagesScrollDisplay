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
    var direction:CGFloat = 1
    var position: Int = 0
    
    
    
    
    
    let source: dispatch_source_t = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue())
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initImagesNameArray()
        self.configScrollView()
        self.initButtonContentView()
        self.initButtons()
        self.addDispatchSourceTimer()
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
    
    
    private func addDispatchSourceTimer() {
        dispatch_source_set_timer(source, DISPATCH_TIME_NOW, UInt64(3 * NSEC_PER_SEC), 0)
        dispatch_source_set_event_handler(source) {
            UIView.animateWithDuration(0.7, animations: { 
                
            })
            UIView.animateWithDuration(0.7, animations: {
                self.contentOffset.x = self.contentOffset.x + (self.width * self.direction)  - 1
            }, completion: { (result) in
                if result {
                    self.contentOffset.x += 1
                }
            })
        }
        dispatch_resume(source)
    }
    
    //MARK -- UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.moveImageView(scrollView.contentOffset.x)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.x - self.width > 0 {
            direction = 1
        } else {
            direction = -1
        }
    }
    
    func moveImageView(offsetX: CGFloat) {
        let temp = offsetX / self.width
        
        if temp == 0 || temp == 1 || temp == 2 {
            position = Int(temp) - 1
            self.currentPage = getCurrentImageIndex(self.currentPage + position)
            self.setButtonSameImage(self.currentPage)
            self.contentOffset.x = self.width
            self.setButtonImage(self.currentPage)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
