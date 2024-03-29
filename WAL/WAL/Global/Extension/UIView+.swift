//
//  UIView+.swift
//  WAL
//
//  Created by Thisisme Hi on 2022/04/01.
//

import UIKit

extension UIView {
    func makeShadow(_ color: UIColor, _ opacity: Float, _ offset: CGSize, _ radius: CGFloat) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
    }
    
    func makeRound(radius: CGFloat = 4) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
    
    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
    
    func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
        
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
