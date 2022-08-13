//
//  SettingService.swift
//  WAL
//
//  Created by heerucan on 2022/08/13.
//

import Moya

enum SettingService {
    case checkUserInfo
    case editUserInfo(nickname: String)
    case checkTime
    case editTime(morning: Bool, afternoon: Bool, night: Bool)
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
        case .editUserInfo(let nickname):
            return .requestParameters(
                parameters: ["nickname": nickname],
                encoding: URLEncoding.default)
        case .editTime(let morning,
                       let afternoon,
                       let night):
            return .requestParameters(
                parameters: ["morning": morning,
                             "afternoon": afternoon,
                             "night": night],
                encoding: URLEncoding.default)
        case .editCategory(let param):
            return .requestJSONEncodable(param)
        }
    }
}
