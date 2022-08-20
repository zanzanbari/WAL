//
//  WALStatus.swift
//  WAL
//
//  Created by 소연 on 2022/08/13.
//

import UIKit

import WALKit

enum WALStatus {
    case sleeping
    case checkedAll
    case arrived
    
    var subTitle: String {
        switch self {
        case .sleeping:
            return "왈뿡이가 자는 시간이에요. 아침에 만나요!"
        case .checkedAll, .arrived:
            return "다들 밥 잘 먹어! 난 뼈다구가 젤루 좋아"
        }
    }
    
    var content: String {
        switch self {
        case .sleeping:
            return ""
        case .checkedAll:
            return "새로운 왈소리를 기다려보세요"
        case .arrived:
            return "왈소리가 도착했어요\n발바닥을 탭하여 확인해주세요"
        }
    }
    
    var walImage: UIImage {
        switch self {
        case .sleeping:
            return WALIcon.imgWalBBongSleeping.image
        case .checkedAll:
            return WALIcon.imgWalBBongWaiting.image
        case .arrived:
            let walArrivedImageList: [UIImage] = [WALIcon.imgWalBBongArrive1.image,
                                                  WALIcon.imgWalBBongArrive2.image,
                                                  WALIcon.imgWalBBongArrive3.image]
            return walArrivedImageList.randomElement() ?? WALIcon.imgWalBBongArrive1.image
        }
    }
}
