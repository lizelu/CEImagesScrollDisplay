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
    
    func initImagesNameArray() -> Array<String>{
        var imagesNameArray: Array<String> = []
        for i in 0..<10 {
            imagesNameArray.append("00\(i).jpg")
        }
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

