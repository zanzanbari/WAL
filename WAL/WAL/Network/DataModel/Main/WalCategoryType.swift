//
//  WalCategoryType.swift
//  WAL
//
//  Created by 소연 on 2023/04/27.
//

import UIKit

import WALKit

/// 왈 타입
enum WalCategoryType: String, CaseIterable {
    case comedy          = "COMEDY"
    case fuss            = "FUSS"
    case comfort         = "COMFORT"
    case yell            = "YELL"
    case reservation     = "RESERVATION"
    case none            = ""
    
    var categoryId: Int {
        switch self {
        case .none:             return -999
        case .comedy:           return 0
        case .fuss:             return 1
        case .comfort:          return 2
        case .yell:             return 3
        case .reservation:      return -1
        }
    }
    
    var walImage: UIImage? {
        switch self {
        case .none:             return nil
        case .comedy:           return WALIcon.imgWallbbongFun.image
        case .fuss:             return WALIcon.imgWallbbongLove.image
        case .comfort:          return WALIcon.imgWallbbongCheer.image
        case .yell:             return WALIcon.imgWallbbongAngry.image
        case .reservation:      return WALIcon.imgWalbbongSpecial.image
        }
    }
}
