//
//  WALContentType.swift
//  WAL
//
//  Created by 소연 on 2022/08/12.
//

import UIKit

import WALKit

enum WALContentType {
    case fun
    case angry
    case cheer
    case love
    case special
    
    var walImage: UIImage {
        switch self {
        case .fun:
            return WALIcon.imgWallbbongFun.image
        case .angry:
            return WALIcon.imgWallbbongAngry.image
        case .cheer:
            return WALIcon.imgWallbbongCheer.image
        case .love:
            return WALIcon.imgWallbbongLove.image
        case .special:
            return WALIcon.imgWalbbongSpecial.image
        }
    }
}
