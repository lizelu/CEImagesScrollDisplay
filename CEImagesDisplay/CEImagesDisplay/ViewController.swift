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
        for i in 0..<9 {
            imagesNameArray.append("00\(i).jpg")
        }
        
        //添加图片对象
        if let image = UIImage(named:"009.jgp"){
            imagesNameArray.append(image)
        }
        
        //添加网络图片
        imagesNameArray.append("http://pic72.nipic.com/file/20150716/21422793_144600530000_2.jpg")
        imagesNameArray.append("http://img2.3lian.com/img2007/4/22/303952037bk.jpg")
        imagesNameArray.append("http://img.61gequ.com/allimg/2011-4/201142614314278502.jpg")
        imagesNameArray.append("http://img4.imgtn.bdimg.com/it/u=3673450456,2434143346&fm=21&gp=0.jpg")
        imagesNameArray.append("http://pic72.nipic.com/file/20150716/21422793_144600530000_2.jpg")
        imagesNameArray.append("http://img2.3lian.com/img2007/4/22/303952037bk.jpg")
        imagesNameArray.append("http://img.61gequ.com/allimg/2011-4/201142614314278502.jpg")
        
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

