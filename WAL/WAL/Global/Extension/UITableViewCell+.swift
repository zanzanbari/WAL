//
//  UITableViewCell+.swift
//  WAL
//
//  Created by heerucan on 2023/05/07.
//

import UIKit

extension UITableViewCell {
    
    static func register(_ target: UITableView) {
        target.register(Self.self, forCellReuseIdentifier:Self.identifier)
    }
    
}
