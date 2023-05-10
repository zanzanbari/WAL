//
//  OnboardService.swift
//  WAL
//
//  Created by heerucan on 2022/06/24.
//

import Moya

enum OnboardService {
    case onboard(OnboardRequest)
}

extension OnboardService: BaseTargetType {
    
    var path: String {
        switch self {
        case .onboard: return "/onboard"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default: return .post
        }
    }
    
    var task: Task {
        switch self {
        case .onboard(let param):
            return .requestJSONEncodable(param)
        }
    }
}

