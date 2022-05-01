//
//  WALFont.swift
//  WAL
//
//  Created by heerucan on 2022/05/01.
//

import UIKit

/** WAL Typo System */

public struct FontProperty {
    let font: UIFont.FontType
    let size: CGFloat
    let kern: CGFloat
    let lineHeight: CGFloat?
}

public enum WALFont {
    case title1
    case title2
    case body1
    case body2
    case body3
    case body4
    case body5
    case body6
    case body7
    case body8
    case body9
    
    public var fontProperty: FontProperty {
        switch self {
        case .title1:
            return FontProperty(font: .semibold, size: 20, kern: -0.3, lineHeight: nil)
        case .title2:
            return FontProperty(font: .medium, size: 20, kern: -0.3, lineHeight: 20)
        case .body1:
            return FontProperty(font: .semibold, size: 18, kern: -0.3, lineHeight: nil)
        case .body2:
            return FontProperty(font: .medium, size: 18, kern: -0.3, lineHeight: nil)
        case .body3:
            return FontProperty(font: .regular, size: 18, kern: -0.3, lineHeight: 28)
        case .body4:
            return FontProperty(font: .medium, size: 16, kern: -0.3, lineHeight: nil)
        case .body5:
            return FontProperty(font: .regular, size: 16, kern: -0.3, lineHeight: 25)
        case .body6:
            return FontProperty(font: .regular, size: 16, kern: -0.3, lineHeight: 22)
        case .body7:
            return FontProperty(font: .regular, size: 15, kern: -0.3, lineHeight: 21)
        case .body8:
            return FontProperty(font: .regular, size: 14, kern: -0.3, lineHeight: nil)
        case .body9:
            return FontProperty(font: .regular, size: 13, kern: -0.3, lineHeight: nil)
        }
    }
}

public extension WALFont {
    var font: UIFont {
        guard let font = UIFont(name: fontProperty.font.name, size: fontProperty.size) else {
            return UIFont()
        }
        return font
    }
}
