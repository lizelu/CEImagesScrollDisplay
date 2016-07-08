//
//  ViewController.swift
//  CEImagesDisplay
//
//  Created by Mr.LuDashi on 16/7/6.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let screenWidth = UIScreen.mainScreen().bounds.width

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.addImageDisplayView()
    }
    
    func addImageDisplayView() {
        let imageScrollView: CEImagesDisplayView = CEImagesDisplayView.init(frame: CGRectMake(0, 100, self.screenWidth, 300))
        self.view.addSubview(imageScrollView)
        
        imageScrollView.setImages(initImagesNameArray())
        imageScrollView.setButtonTouchUpInsideClosure { (index) in
            print("图片\(index)")
        }
    }
    
    func initImagesNameArray() -> Array<AnyObject>{
        var imagesNameArray: Array<AnyObject> = []
        //添加本地图片
//        for i in 0..<6 {
//            imagesNameArray.append("00\(i).jpg")
//        }
        
        //添加网络图片

        imagesNameArray.append("http://pic72.nipic.com/file/20150716/21422793_144600530000_2.jpg")
        imagesNameArray.append("http://img2.3lian.com/img2007/4/22/303952037bk.jpg")
        imagesNameArray.append("http://img.61gequ.com/allimg/2011-4/201142614314278502.jpg")
        imagesNameArray.append("http://img15.3lian.com/2015/f1/5/d/108.jpg")
        imagesNameArray.append("http://pic1.nipic.com/2008-12-25/2008122510134038_2.jpg")
        imagesNameArray.append("http://img3.3lian.com/2013/v10/79/d/86.jpg")
        
        
        return imagesNameArray
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit{
        print("释放")
    }
}

