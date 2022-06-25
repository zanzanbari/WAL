//
//  OnboardService.swift
//  WAL
//
//  Created by heerucan on 2022/06/24.
//

import Moya

enum OnboardService {
    case setInfo(param: OnboardRequest)
}

extension OnboardService: BaseTargetType {
    
    var path: String {
        switch self {
        case .setInfo: return "/user/set-info"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default: return .post
        }
    }
    
    var task: Task {
        switch self {
        case .setInfo(let param):
            return .requestJSONEncodable(param)
        }
    }
}

