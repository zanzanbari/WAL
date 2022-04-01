//
//  UIStackView+.swift
//  WAL
//
//  Created by Thisisme Hi on 2022/04/01.
//

import UIKit

extension UIStackView {
    public func addArrangedSubviews(_ view: [UIView]) {
        view.forEach { self.addArrangedSubview($0) }
    }
}
