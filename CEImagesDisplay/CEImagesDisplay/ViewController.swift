//
//  ViewController.swift
//  CEImagesDisplay
//
//  Created by Mr.LuDashi on 16/7/6.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.addImageDisplayView()
    }
    
    func addImageDisplayView() {
        let imageScrollView: CEImagesDisplayView = CEImagesDisplayView.init(frame: CGRect(x: 0, y: 80, width: self.screenWidth, height: 260))
        self.view.addSubview(imageScrollView)
        
        imageScrollView.setImages(initImagesNameArray())
        imageScrollView.setButtonTouchUpInsideClosure { (index) in
            print("图片\(index)")
        }
    }
    
    func initImagesNameArray() -> Array<AnyObject>{
        var imagesNameArray: Array<AnyObject> = []
        //添加本地图片
        for i in 0..<9 {
            imagesNameArray.append("00\(i).jpg" as AnyObject)
        }
        imagesNameArray.append(UIImage(named: "009.jpg")!)
        
        //添加网络图片
        imagesNameArray.append("http://pic72.nipic.com/file/20150716/21422793_144600530000_2.jpg" as AnyObject)
        imagesNameArray.append("http://img2.3lian.com/img2007/4/22/303952037bk.jpg" as AnyObject)
        imagesNameArray.append("http://img.61gequ.com/allimg/2011-4/201142614314278502.jpg" as AnyObject)
        imagesNameArray.append("http://img15.3lian.com/2015/f1/5/d/108.jpg" as AnyObject)
        imagesNameArray.append("http://pic1.nipic.com/2008-12-25/2008122510134038_2.jpg" as AnyObject)
        imagesNameArray.append("http://img3.3lian.com/2013/v10/79/d/86.jpg" as AnyObject)
        
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

