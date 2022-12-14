//
//  WALContentType.swift
//  WAL
//
//  Created by 소연 on 2022/08/12.
//

import UIKit

import WALKit

enum WALContentType: Int {
    case special = -1
    case fun = 0
    case love = 1
    case cheer = 2
    case angry = 3
    
    var walImage: UIImage {
        switch self {
        case .special:
            return WALIcon.imgWalbbongSpecial.image
        case .fun:
            return WALIcon.imgWallbbongFun.image
        case .love:
            return WALIcon.imgWallbbongLove.image
        case .cheer:
            return WALIcon.imgWallbbongCheer.image
        case .angry:
            return WALIcon.imgWallbbongAngry.image
        }
    }
}
