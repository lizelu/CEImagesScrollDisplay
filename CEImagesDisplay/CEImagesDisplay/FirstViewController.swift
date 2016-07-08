//
//  FirstViewController.swift
//  CEImagesDisplay
//
//  Created by Mr.LuDashi on 16/7/8.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet var testImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageURLString = "http://pic72.nipic.com/file/20150716/21422793_144600530000_2.jpg"
        testImageView.ce_setImage(imageURLString)
        print(NSHomeDirectory())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
