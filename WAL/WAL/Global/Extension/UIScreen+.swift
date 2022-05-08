//
//  UIScreen+.swift
//  WAL
//
//  Created by Thisisme Hi on 2022/04/01.
//

import UIKit

extension UIScreen {
    public var hasNotch: Bool{
        let deviceRatio = UIScreen.main.bounds.width / UIScreen.main.bounds.height
        if deviceRatio > 0.5{
            return false
        } else {
            return true
        }
    }
}
