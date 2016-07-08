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
    
    private var imagesNameArray: Array<AnyObject> = []             //图片数组
    private var buttonsArray: Array<CEImageViewButton> = []     //存储三个按钮
    private var currentPage: Int = 0                            //当前页数
    private var direction:CGFloat = 1                           //运动方向，1 <==> right, -1 <==> left
    private var isSourceActive: Bool = false                    //定时器是否有效
    private var touchUpInsideClosure: ButtonTouchUpInsideClosureTag!    //按钮点击事件回调
    private var duration: Float = 5                             //运动时间间隔
    private let queue: dispatch_queue_t = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT)
    
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
    
    func setImages(imagesNameArray: Array<AnyObject>) {
        self.imagesNameArray = imagesNameArray
        self.requstAllImage(imagesNameArray)
        self.addImagesToButton(imagesNameArray)
    }
    
    func addImagesToButton(imagesNameArray: Array<AnyObject>) {
        if imagesNameArray.count > 0 {
            self.setButtonImage(self.currentPage)
            self.pageControl.numberOfPages = imagesNameArray.count
            self.currentPage = 0;
        }
    }
    
    
    private func requstAllImage(imageArray: Array<AnyObject>) {
        for i in 0..<imageArray.count {
            let imageName = imageArray[i]
            
            guard let imageNameString = imageName as? String else {
                continue
            }
            
            if isURLString(imageNameString) {
               dispatch_async(queue, {
                    self.requestImage(imageNameString, index: i)
               })
            }
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

    /**
     设置按钮上应显示的图片
     
     - parameter currentPage: 当前页数
     */
    private func setButtonImage(currentPage: Int) {
        
        let imageIndexArray = [getBeforeImageIndex(currentPage),
                               getCurrentImageIndex(currentPage),
                               getLastImageIndex(currentPage)]
        
        for i in 0..<self.buttonsArray.count {
            let tempButton = self.buttonsArray[i]
            let imageName = self.imagesNameArray[imageIndexArray[i]]
            tempButton.addImageToImageView(imageName)
        }
    }
    
    
    /**
     获取当前显示图片索引
     
     - parameter currentPage: 当前页数
     
     - returns:
     */
    private func getCurrentImageIndex(currentPage: Int) -> Int {
        if self.imagesNameArray.count > 0 {
            let tempCurrentPage = currentPage % self.imagesNameArray.count
            return tempCurrentPage < 0 ? self.imagesNameArray.count - 1 : tempCurrentPage
        }
        return 0
    }
    
    /**
     获取当前显示图片的上一张图片的索引
     
     - parameter currentPage:
     
     - returns:
     */
    private func getBeforeImageIndex(currentPage: Int) -> Int {
        let beforeNumber = getCurrentImageIndex(currentPage) - 1
        return beforeNumber < 0 ? self.imagesNameArray.count - 1 : beforeNumber
    }
    
    /**
     获取当前图片显示的下一张图片的索引
     
     - parameter currentPage:
     
     - returns:
     */
    private func getLastImageIndex(currentPage: Int) -> Int {
        let lastNumber = getCurrentImageIndex(currentPage) + 1
        return lastNumber >= self.imagesNameArray.count ? 0 : lastNumber
    }
    
    /**
     获取每个按钮的Frame
     
     - parameter index:
     
     - returns:
     */
    private func getButtonFrameWithIndex(index: Int) -> CGRect{
        return CGRectMake(CGFloat(index) * self.width, 0, self.width, self.height)
    }
    
    
    
    //MARK -- UIScrollViewDelegate
    /**
     移动Button到合适的位置
     
     - parameter scrollView:
     */
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.moveImageView(scrollView.contentOffset.x)
    }
    
    /**
     记录用户拖动方向
     
     - parameter scrollView:
     - parameter decelerate:
     */
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.x - self.width > 0 {
            direction = 1
        } else {
            direction = -1
        }
    }
    
    /**
     开始拖动时，挂起定时器
     
     - parameter scrollView:
     */
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if self.isSourceActive {
            dispatch_suspend(source)
            self.isSourceActive = false
        }
    }
    
    /**
     拖动结束时，唤醒定时器
     
     - parameter scrollView:
     */
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {

        if !self.isSourceActive && dispatch_source_get_handle(source) != 0 {
            dispatch_resume(source)
            self.isSourceActive = true
        }
    }
    
    /**
     移动Button到合适的位置
     
     - parameter offsetX:
     */
    func moveImageView(offsetX: CGFloat) {
        let temp = offsetX / self.width
        
        if temp == 0 || temp == 1 || temp == 2 {
            let position: Int = Int(temp) - 1
            self.currentPage = getCurrentImageIndex(self.currentPage + position)
            self.scrollView.contentOffset.x = self.width
            self.setButtonImage(self.currentPage)
            self.pageControl?.currentPage = self.currentPage
        }
    }
    

    /**
     从网络加载图片
     
     - parameter imageURLString: imageURL
     - parameter index:          图片索引
     */
    private func requestImage(imageURLString: String, index: Int) {
        guard let imageURL: NSURL = NSURL.init(string: imageURLString) else {
            return
        }
        
        let request: NSMutableURLRequest = NSMutableURLRequest.init(URL: imageURL)
        request.cachePolicy = .UseProtocolCachePolicy
        
        let session: NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let sessionDataTask: NSURLSessionDataTask = session.dataTaskWithRequest(request) { (data, respons, error) in
            if error != nil {
                print(error?.description)
                return
            }
            
            guard let imageData = data else {
                return
            }
            
            guard let image: UIImage = UIImage.init(data: imageData) else {
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.imagesNameArray[index] = image
                self.moveImageView(self.scrollView.contentOffset.x)
            })
        }
        sessionDataTask.resume()
    }

    /**
     图片URL实现
     
     - parameter imageName: <#imageName description#>
     
     - returns: <#return value description#>
     */
    private func isURLString(imageName: String) -> Bool {
        let pattern = "((http|ftp|https)://)(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?"
        let predicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluateWithObject(imageName)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
