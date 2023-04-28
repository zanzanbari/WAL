//
//  AlarmTimeType.swift
//  WAL
//
//  Created by 소연 on 2023/04/27.
//

import UIKit

import WALKit

/// 시간 타입
enum AlarmTimeType: String {
    case none         = ""
    case morning      = "MORNING"
    case night        = "NIGHT"
    case afternoon    = "AFTERNOON"
    
    var pawImage: UIImage? {
        switch self {
        case .none:   return WALIcon.imgPawSpecial.image
        default:      return WALIcon.imgPawActive.image
        }
    }
    
    var color: UIColor {
        switch self {
        case .none:
            return UIColor.mint100
        default:
            return UIColor.orange100
        }
    }
}
