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
    
    fileprivate var width: CGFloat {
        get {
            return self.frame.size.width
        }
    }
    
    fileprivate var height: CGFloat {
        get {
            return self.frame.size.height
        }
    }
    
    fileprivate var imagesNameArray: Array<AnyObject> = []             //图片数组
    fileprivate var buttonsArray: Array<CEImageViewButton> = []     //存储三个按钮
    fileprivate var currentPage: Int = 0                            //当前页数
    fileprivate var direction:CGFloat = 1                           //运动方向，1 <==> right, -1 <==> left
    fileprivate var isSourceActive: Bool = false                    //定时器是否有效
    fileprivate var touchUpInsideClosure: ButtonTouchUpInsideClosureTag!    //按钮点击事件回调
    fileprivate var duration: Float = 5                             //运动时间间隔
    fileprivate let queue: DispatchQueue = DispatchQueue(label: "queue", attributes: DispatchQueue.Attributes.concurrent)
    
    fileprivate var pageControl: UIPageControl!
    fileprivate var pageControlHeight: CGFloat = 50
    fileprivate var scrollView: UIScrollView!
    
    let source: DispatchSourceTimer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: UInt(0)), queue: DispatchQueue.main) as! DispatchSource
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configScrollView()
        self.initButtons()
        self.initPageControl()
        self.addDispatchSourceTimer()
    }
    
    
    func setButtonTouchUpInsideClosure(_ closure: @escaping ButtonTouchUpInsideClosureTag) {
        self.touchUpInsideClosure = closure
    }
    
    func setImages(_ imagesNameArray: Array<AnyObject>) {
        self.imagesNameArray = imagesNameArray
        self.requstAllImage(imagesNameArray)
        self.addImagesToButton(imagesNameArray)
    }
    
    func addImagesToButton(_ imagesNameArray: Array<AnyObject>) {
        if imagesNameArray.count > 0 {
            self.setButtonImage(self.currentPage)
            self.pageControl.numberOfPages = imagesNameArray.count
            self.currentPage = 0;
        }
    }
    
    
    fileprivate func requstAllImage(_ imageArray: Array<AnyObject>) {
        for i in 0..<imageArray.count {
            let imageName = imageArray[i]
            
            guard let imageNameString = imageName as? String else {
                continue
            }
            
            if isURLString(imageNameString) {
               queue.async(execute: {
                    self.requestImage(imageNameString, index: i)
               })
            }
        }
    }
    
    fileprivate func configScrollView() {
        self.scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height))
        self.scrollView.bounces = false
        self.scrollView.delegate = self
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.backgroundColor = UIColor.gray
        self.scrollView.contentSize = CGSize(width: 3 * self.width, height: self.height)
        self.scrollView.isPagingEnabled = true
        self.scrollView.contentOffset.x = self.width
        self.addSubview(self.scrollView)
    }
    
    fileprivate func initButtons() {
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
    
    fileprivate func initPageControl() {
        self.pageControl = UIPageControl(frame: CGRect(x: 0, y: self.height - pageControlHeight, width: self.width, height: pageControlHeight))
        self.addSubview(self.pageControl)
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
    }
    
    fileprivate func addDispatchSourceTimer() {
        let timer = UInt64(duration) * NSEC_PER_SEC
        source.scheduleRepeating(deadline: DispatchTime.init(uptimeNanoseconds: UInt64(timer)), interval: DispatchTimeInterval.seconds(Int(duration)), leeway: DispatchTimeInterval.seconds(0))
        //source.setTimer(start: DispatchTime.now() + Double(Int64(timer)) / Double(NSEC_PER_SEC), interval: timer, leeway: 0)
        source.setEventHandler {
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.contentOffset.x = self.scrollView.contentOffset.x + (self.width * self.direction)  - 1
                }, completion: { (result) in
                    if result {
                        self.scrollView.contentOffset.x += 1
                    }
            })
        }
        source.resume()
        self.isSourceActive = true
    }

    /**
     设置按钮上应显示的图片
     
     - parameter currentPage: 当前页数
     */
    fileprivate func setButtonImage(_ currentPage: Int) {
        
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
    fileprivate func getCurrentImageIndex(_ currentPage: Int) -> Int {
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
    fileprivate func getBeforeImageIndex(_ currentPage: Int) -> Int {
        let beforeNumber = getCurrentImageIndex(currentPage) - 1
        return beforeNumber < 0 ? self.imagesNameArray.count - 1 : beforeNumber
    }
    
    /**
     获取当前图片显示的下一张图片的索引
     
     - parameter currentPage:
     
     - returns:
     */
    fileprivate func getLastImageIndex(_ currentPage: Int) -> Int {
        let lastNumber = getCurrentImageIndex(currentPage) + 1
        return lastNumber >= self.imagesNameArray.count ? 0 : lastNumber
    }
    
    /**
     获取每个按钮的Frame
     
     - parameter index:
     
     - returns:
     */
    fileprivate func getButtonFrameWithIndex(_ index: Int) -> CGRect{
        return CGRect(x: CGFloat(index) * self.width, y: 0, width: self.width, height: self.height)
    }
    
    
    
    //MARK -- UIScrollViewDelegate
    /**
     移动Button到合适的位置
     
     - parameter scrollView:
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.moveImageView(scrollView.contentOffset.x)
    }
    
    /**
     记录用户拖动方向
     
     - parameter scrollView:
     - parameter decelerate:
     */
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
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
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.isSourceActive {
            source.suspend()
            self.isSourceActive = false
        }
    }
    
    /**
     拖动结束时，唤醒定时器
     
     - parameter scrollView:
     */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if !self.isSourceActive && source.handle != 0 {
            source.resume()
            self.isSourceActive = true
        }
    }
    
    /**
     移动Button到合适的位置
     
     - parameter offsetX:
     */
    func moveImageView(_ offsetX: CGFloat) {
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
    fileprivate func requestImage(_ imageURLString: String, index: Int) {
        guard let imageURL: URL = URL.init(string: imageURLString) else {
            return
        }
        
        let request: NSMutableURLRequest = NSMutableURLRequest.init(url: imageURL)
        request.cachePolicy = .useProtocolCachePolicy
        
        let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
        
        let sessionDataTask: URLSessionDataTask = session.dataTask(with: imageURL) { (data, respons, error) in
            if error != nil {
                print(error)
                return
            }
            
            guard let imageData = data,
                let image: UIImage = UIImage.init(data: imageData) else {
                    return
            }
            
            DispatchQueue.main.async(execute: {
                print(index)
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
    fileprivate func isURLString(_ imageName: String) -> Bool {
        let pattern = "((http|ftp|https)://)(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?"
        let predicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: imageName)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
