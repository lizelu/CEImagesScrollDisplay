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
        let imageScrollView: CEImagesScrollView = CEImagesScrollView.init(frame: CGRectMake(0, 100, self.screenWidth, 300))
        self.view.addSubview(imageScrollView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit{
        print("释放")
    }
}

