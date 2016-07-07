//
//  CEImagesScrollView.swift
//  CEImagesDisplay
//
//  Created by Mr.LuDashi on 16/7/6.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

import UIKit

typealias ButtonTouchUpInsideClosureTag = (Int) -> Void

class CEImagesDisplayView: UIView, UIScrollViewDelegate {
    
    private var width: CGFloat {
        get {
            return self.frame.size.width
        }
    }
    
    private var height: CGFloat {
        get {
            return self.frame.size.height
        }
    }
    
    private var imagesNameArray: Array<String> = []
    private var buttonsArray: Array<CEImageViewButton> = []
    private var currentPage: Int = 0
    private var direction:CGFloat = 1
    private var position: Int = 0
    private var isSourceActive: Bool = false
    private var touchUpInsideClosure: ButtonTouchUpInsideClosureTag!
    private var duration: Float = 5
    
    private var pageControl: UIPageControl!
    private var pageControlHeight: CGFloat = 50
    private var scrollView: UIScrollView!
    
    
    let source: dispatch_source_t = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configScrollView()
        self.initButtons()
        self.initPageControl()
        self.addDispatchSourceTimer()
    }
    
    
    func setButtonTouchUpInsideClosure(closure: ButtonTouchUpInsideClosureTag) {
        self.touchUpInsideClosure = closure
    }
    
    func setImages(imagesNameArray: Array<String>) {
        self.imagesNameArray = imagesNameArray
        if imagesNameArray.count > 0 {
            self.setButtonImage(self.currentPage)
            self.pageControl.numberOfPages = imagesNameArray.count
            self.currentPage = 0;
        }
    }
    
    private func configScrollView() {
        self.scrollView = UIScrollView.init(frame: CGRectMake(0, 0, self.width, self.height))
        self.scrollView.bounces = false
        self.scrollView.delegate = self
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.backgroundColor = UIColor.grayColor()
        self.scrollView.contentSize = CGSizeMake(3 * self.width, self.height)
        self.scrollView.pagingEnabled = true
        self.scrollView.contentOffset.x = self.width
        self.addSubview(self.scrollView)
    }
    
    private func initButtons() {
        for i in 0..<3 {
            let tempButton: CEImageViewButton = CEImageViewButton.init(frame: getButtonFrameWithIndex(i))
            tempButton.tag = i
            self.scrollView.addSubview(tempButton)
            self.buttonsArray.append(tempButton)
            
            tempButton.setButtonTouchUpInsideClosure({ (sender) in
                self.touchUpInsideClosure(self.currentPage)
            })
        }
    }
    
    private func initPageControl() {
        self.pageControl = UIPageControl(frame: CGRectMake(0, self.height - pageControlHeight, self.width, pageControlHeight))
        self.addSubview(self.pageControl)
        self.pageControl.pageIndicatorTintColor = UIColor.whiteColor()
        self.pageControl.currentPageIndicatorTintColor = UIColor.blackColor()
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
        if self.imagesNameArray.count > 0 {
            let tempCurrentPage = currentPage % self.imagesNameArray.count
            return tempCurrentPage < 0 ? self.imagesNameArray.count - 1 : tempCurrentPage
        }
        return 0
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
        let timer = UInt64(duration) * NSEC_PER_SEC
        dispatch_source_set_timer(source, dispatch_time(DISPATCH_TIME_NOW,  Int64(timer)), timer, 0)
        dispatch_source_set_event_handler(source) {
    
            UIView.animateWithDuration(0.3, animations: {
                self.scrollView.contentOffset.x = self.scrollView.contentOffset.x + (self.width * self.direction)  - 1
            }, completion: { (result) in
                if result {
                    self.scrollView.contentOffset.x += 1
                }
            })
        }
        dispatch_resume(source)
        self.isSourceActive = true
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
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        if self.isSourceActive {
            dispatch_suspend(source)
            self.isSourceActive = false
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {

        if !self.isSourceActive && dispatch_source_get_handle(source) != 0 {
            dispatch_resume(source)
            self.isSourceActive = true
        }
    }
    
    
    
    func moveImageView(offsetX: CGFloat) {
        let temp = offsetX / self.width
        
        if temp == 0 || temp == 1 || temp == 2 {
            position = Int(temp) - 1
            self.currentPage = getCurrentImageIndex(self.currentPage + position)
            self.setButtonSameImage(self.currentPage)
            self.scrollView.contentOffset.x = self.width
            self.setButtonImage(self.currentPage)
            self.pageControl?.currentPage = self.currentPage
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
