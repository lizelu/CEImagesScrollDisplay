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
    private static var requstImageDic: Dictionary<String, UIImage> = [:]
    private var buttonImageView: UIImageView!
    private var touchUpInsideClosure: ButtonTouchUpInsideClosure!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configButton()
        self.addButtonImageView()
    }
    
    func setButtonTouchUpInsideClosure(closure: ButtonTouchUpInsideClosure) {
        self.touchUpInsideClosure = closure
    }
    
    func addImageToImageView (name: String) {

        
        if isURLString(name) {
            self.buttonImageView.sd_setImageWithURL(NSURL(string: name), placeholderImage: UIImage(named: "place_image"))
        } else {
            guard let image = UIImage(named: name) else {
                return
            }
            self.buttonImageView.image = image
        }
    }
    private func configButton() {
        self.addTarget(self, action: #selector(tapButton), forControlEvents: .TouchUpInside)
        self.clipsToBounds = true
    }
    
    private func addButtonImageView() {
        self.buttonImageView = UIImageView.init(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        self.buttonImageView.contentMode = .ScaleAspectFill
        self.addSubview(self.buttonImageView)
    }
    
    @objc private func tapButton(sender: UIButton) {
        if self.touchUpInsideClosure != nil {
            self.touchUpInsideClosure(sender)
        }
    }
    
    private func isURLString(imageName: String) -> Bool {
        let pattern = "((http|ftp|https)://)(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?"
        let predicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluateWithObject(imageName)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
