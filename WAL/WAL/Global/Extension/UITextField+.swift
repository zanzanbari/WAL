//
//  UITextField+.swift
//  WAL
//
//  Created by Thisisme Hi on 2022/04/01.
//

import UIKit

extension UITextField {
    func setupPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.frame.height))
        
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
        
        self.rightView = paddingView
        self.rightViewMode = ViewMode.always
    }
}
