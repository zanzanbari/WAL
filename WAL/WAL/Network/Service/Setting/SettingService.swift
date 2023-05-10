//
//  SettingService.swift
//  WAL
//
//  Created by heerucan on 2022/08/13.
//

import Moya

enum SettingService {
    case checkNickname
    case checkAlarm
    case checkCategory
    case editNickname(String)
    case editAlarm(UserAlarmRequest)
    case editCategory(UserCategoryRequest)
}

extension SettingService: BaseTargetType {
    
    var path: String {
        switch self {
        case .checkNickname: return "/user/me/nickname"
        case .checkAlarm: return "user/me/time"
        case .checkCategory: return "user/me/category"
        case .editNickname: return "/user/me/nickname/edit"
        case .editAlarm: return "/onboard/time/edit"
        case .editCategory: return "/onboard/category/edit"
        }
    }
    
    var method: Method {
        switch self {
        case .checkNickname, .checkAlarm, .checkCategory: return .get
        case .editNickname: return .patch
        case .editAlarm, .editCategory: return .post
        }
    }
    
    var task: Task {
        switch self {
        case .checkNickname, .checkAlarm, .checkCategory:
            return .requestPlain
        case .editNickname(let nickname):
            return .requestJSONEncodable(nickname)
        case .editAlarm(let param):
            return .requestJSONEncodable(param)
        case .editCategory(let param):
            return .requestJSONEncodable(param)
        }
    }
}
