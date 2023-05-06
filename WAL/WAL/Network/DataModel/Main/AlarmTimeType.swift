//
//  AlarmTimeType.swift
//  WAL
//
//  Created by 소연 on 2023/04/27.
//

import UIKit

import WALKit

/// 시간 타입
enum AlarmTimeType: String, CaseIterable {
    case morning      = "MORNING"
    case afternoon    = "AFTERNOON"
    case night        = "NIGHT"
    case none         = ""

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
