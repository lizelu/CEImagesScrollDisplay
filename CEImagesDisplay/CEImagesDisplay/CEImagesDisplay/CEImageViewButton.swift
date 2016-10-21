//
//  CEImageViewButton.swift
//  CEImagesDisplay
//
//  Created by Mr.LuDashi on 16/7/7.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

import UIKit

typealias ButtonTouchUpInsideClosure = (UIButton) -> Void

class CEImageViewButton: UIButton {
    fileprivate static var requstImageDic: Dictionary<String, UIImage> = [:]
    fileprivate var buttonImageView: UIImageView!
    fileprivate var touchUpInsideClosure: ButtonTouchUpInsideClosure!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configButton()
        self.addButtonImageView()
    }
    
    func setButtonTouchUpInsideClosure(_ closure: @escaping ButtonTouchUpInsideClosure) {
        self.touchUpInsideClosure = closure
    }
    
    func addImageToImageView (_ name: AnyObject) {
        guard var imageNameString = name as? String else {
            guard let image = name as? UIImage else {
                return
            }
            self.buttonImageView.image = image
            return
        }
        
        if isURLString(imageNameString) {
            imageNameString = "place_image"
        }
        
        guard let image = UIImage(named: imageNameString) else {
            return
        }
        self.buttonImageView.image = image
    }
    fileprivate func configButton() {
        self.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        self.clipsToBounds = true
    }
    
    fileprivate func addButtonImageView() {
        self.buttonImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        self.buttonImageView.contentMode = .scaleAspectFill
        self.addSubview(self.buttonImageView)
    }
    
    @objc fileprivate func tapButton(_ sender: UIButton) {
        if self.touchUpInsideClosure != nil {
            self.touchUpInsideClosure(sender)
        }
    }
    
    fileprivate func isURLString(_ imageName: String) -> Bool {
        let pattern = "((http|ftp|https)://)(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?"
        let predicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: imageName)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
