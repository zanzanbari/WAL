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
    case checkTime
    case editTime(time: AlarmTime)
    case checkCategory
    case editCategory(param: UserCategoryRequest)
}

extension SettingService: BaseTargetType {
    
    var path: String {
        switch self {
        case .checkUserInfo, .editUserInfo: return "/user/info/nickname"
        case .checkTime, .editTime: return "/user/info/time"
        case .checkCategory, .editCategory: return "/user/info/category"
        }
    }
    
    var method: Method {
        switch self {
        case .checkUserInfo, .checkTime, .checkCategory: return .get
        case .editUserInfo, .editTime, .editCategory: return .post
        }
    }
    
    var task: Task {
        switch self {
        case .checkUserInfo, .checkTime, .checkCategory:
            return .requestPlain
        case .editUserInfo(let param):
            return .requestJSONEncodable(param)
        case .editTime(let param):
            return .requestJSONEncodable(param)
        case .editCategory(let param):
            return .requestJSONEncodable(param)
        }
    }
}
