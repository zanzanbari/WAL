//
//  TempModel.swift
//  WAL
//
//  Created by Thisisme Hi on 2022/04/01.
//

import UIKit

import WALKit

enum WALDataType {
    case morning
    case lunch
    case evening
    case special
    
    var image: UIImage {
        switch self {
        case .morning, .lunch, .evening:
            return WALIcon.imgPawActive.image
        case .special:
            return WALIcon.imgPawSpecial.image
        }
    }
    
    var color: UIColor {
        switch self {
        case .morning, .lunch, .evening:
            return UIColor.orange100
        case .special:
            return UIColor.mint100
        }
    }
}
