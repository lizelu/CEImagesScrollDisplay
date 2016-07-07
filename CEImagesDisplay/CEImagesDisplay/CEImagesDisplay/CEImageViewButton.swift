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
    var buttonImageView: UIImageView!
    private var touchUpInsideClosure: ButtonTouchUpInsideClosure!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configButton()
        self.addButtonImageView()
    }
    
    func setButtonTouchUpInsideClosure(closure: ButtonTouchUpInsideClosure) {
        self.touchUpInsideClosure = closure
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
        print("点击按钮\(sender.tag)")
        if self.touchUpInsideClosure != nil {
            self.touchUpInsideClosure(sender)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
