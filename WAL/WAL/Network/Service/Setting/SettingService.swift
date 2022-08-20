//
//  SettingService.swift
//  WAL
//
//  Created by heerucan on 2022/08/13.
//

import Moya

enum SettingService {
    case checkUserInfo
    case editUserInfo(nickname: Onboard)
    case checkAlarm
    case editAlarm(alarm: UserAlarmRequest)
    case checkCategory
    case editCategory(category: UserCategoryRequest)
}

extension SettingService: BaseTargetType {
    
    var path: String {
        switch self {
        case .checkUserInfo, .editUserInfo: return "/user/info/nickname"
        case .checkAlarm, .editAlarm: return "/user/info/time"
        case .checkCategory, .editCategory: return "/user/info/category"
        }
    }
    
    var method: Method {
        switch self {
        case .checkUserInfo, .checkAlarm, .checkCategory: return .get
        case .editUserInfo, .editAlarm, .editCategory: return .post
        }
    }
    
    var task: Task {
        switch self {
        case .checkUserInfo, .checkAlarm, .checkCategory:
            return .requestPlain
        case .editUserInfo(let param):
            return .requestJSONEncodable(param)
        case .editAlarm(let param):
            return .requestJSONEncodable(param)
        case .editCategory(let param):
            return .requestJSONEncodable(param)
        }
    }
}
