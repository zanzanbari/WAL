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
        case .comedy:           return 0
        case .fuss:             return 1
        case .comfort:          return 2
        case .yell:             return 3
        case .reservation:      return -1
        case .none:             return -999
        }
    }
    
    var walImage: UIImage? {
        switch self {
        case .comedy:           return WALIcon.imgWallbbongFun.image
        case .fuss:             return WALIcon.imgWallbbongLove.image
        case .comfort:          return WALIcon.imgWallbbongCheer.image
        case .yell:             return WALIcon.imgWallbbongAngry.image
        case .reservation:      return WALIcon.imgWalbbongSpecial.image
        case .none:             return nil
        }
    }
    
    var cardImage: UIImage? {
        switch self {
        case .comedy:           return WALIcon.imgDripInActive.image
        case .fuss:             return WALIcon.imgJujeopInActive.image
        case .comfort:          return WALIcon.imgWeroInActive.image
        case .yell:             return WALIcon.imgGgujungInActive.image
        default:                return nil
        }
    }
    
    var kor: String {
        switch self {
        case .comedy:           return "드립"
        case .fuss:             return "주접"
        case .comfort:          return "위로"
        case .yell:             return "꾸중"
        default:                return ""
        }
    }
    
    var description: String {
        switch self {
        case .comedy:           return "바나나가 웃으면? 바나나킥\n사과가 웃으면? 풋사과"
        case .fuss:             return "너 진짜 답없다.\n문제가 없으니까 뽀뽀쪽"
        case .comfort:          return "지금도 잘하고 있으니까\n너무 조급해하지말자"
        case .yell:             return "일어나자 일어나야지\n오늘도 누워있으면 어떡해"
        default:                return ""
        }
    }
}

struct WalCategoryData {
    func getCardCount() -> Int {
        return 4
    }
    
    func getCategory(index: Int) -> String {
        return WalCategoryType.allCases[index].rawValue
    }
    
    func getCategoryLabel(index: Int) -> String {
        return WalCategoryType.allCases[index].kor
    }
    
    func getCategorySubLabel(index: Int) -> String {
        return WalCategoryType.allCases[index].description
    }
    
    func getWallbbongImage(index: Int) -> UIImage? {
        return WalCategoryType.allCases[index].walImage
    }
    
    func getCardImage(index: Int) -> UIImage? {
        return WalCategoryType.allCases[index].cardImage
    }
}
