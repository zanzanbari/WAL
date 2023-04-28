//
//  UICollectionViewCell+.swift
//  WAL
//
//  Created by 소연 on 2023/04/27.
//

import UIKit

extension UICollectionViewCell {
    
    static func register(_ target: UICollectionView) {
        target.register(Self.self, forCellWithReuseIdentifier: Self.identifier)
    }
    
}
