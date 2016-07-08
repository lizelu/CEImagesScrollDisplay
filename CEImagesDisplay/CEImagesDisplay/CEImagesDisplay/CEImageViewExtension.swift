//
//  CEImageViewExtension.swift
//  CEImagesDisplay
//
//  Created by Mr.LuDashi on 16/7/8.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

import UIKit
extension UIImageView {
    public func ce_setImage(URLString: String, placeholder: String = "place_image") {
        self.image = UIImage(named: placeholder)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.requestImage(URLString)
        }
    }
    
    private func requestImage(imageURLString: String) {
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
                self.image = image;
            })
        }
        sessionDataTask.resume()
    }
}
