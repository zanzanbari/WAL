//
//  UIFont.swift
//  WAL
//
//  Created by heerucan on 2022/05/01.
//

import UIKit

extension UIFont {
    enum FontType: String {
        case regular = "Pretendard-Regular"
        case medium = "Pretendard-Medium"
        case semibold = "Pretendard-Semibold"
        case bold = "Pretendard-Bold"
        
        var name: String {
            return self.rawValue
        }
        
        static func font(_ type: FontType, ofsize size: CGFloat) -> UIFont {
            return UIFont(name: type.rawValue, size: size)!
        }
    }
}
