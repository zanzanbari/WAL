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
    
    var kor: String {
        switch self {
        case .morning:   return "아침"
        case .afternoon: return "점심"
        case .night:     return "저녁"
        case .none:      return ""
        }
    }
    
    var onboardImage: UIImage? {
        switch self {
        case .morning:   return WALIcon.icnMorning.image
        case .afternoon: return WALIcon.icnLaunch.image
        case .night:     return WALIcon.icnEvening.image
        case .none:      return nil
        }
    }

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

struct AlarmTimeData {
    func getTimeCount() -> Int {
        return 3
    }
    
    func getTime(index: Int) -> String {
        return AlarmTimeType.allCases[index].rawValue
    }
    
    func getTimeLabel(index: Int) -> String {
        return AlarmTimeType.allCases[index].kor
    }
    
    func getTimeImage(index: Int) -> UIImage? {
        return AlarmTimeType.allCases[index].onboardImage
    }
}
