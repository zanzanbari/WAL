//
//  UILabel+.swift
//  WAL
//
//  Created by Thisisme Hi on 2022/04/01.
//

import UIKit

extension UILabel {
    func addLetterSpacing(kernValue: Double = -0.4, paragraphValue: CGFloat = 4.0) {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = paragraphValue
            attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
            attributedText = attributedString
            lineBreakStrategy = .hangulWordPriority
        }
    }
    
    func addLineSpacing(spacing: CGFloat) {
        if let text = text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            style.minimumLineHeight = spacing
            style.maximumLineHeight = spacing
            attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, attributeString.length))
            self.attributedText = attributeString
        }
    }
}
