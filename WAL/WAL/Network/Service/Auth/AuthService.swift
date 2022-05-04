//
//  TempService.swift
//  WAL
//
//  Created by Thisisme Hi on 2022/04/01.
//

import Moya

enum AuthService {
    case social(social: String, socialToken: String, fcmToken: String?)
//    case logout
//    case reissue
//    case resign
}

extension AuthService: BaseTargetType {
    
    var path: String {
        switch self {
        case .social(let social, _, _): return "/auth/\(social)/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default: return .post
        }
    }
    
    var task: Task {
        switch self {
        case .social(_, let socialToken, let fcmToken):
            if let fcmToken = fcmToken {
                return .requestParameters(
                    parameters: ["socialtoken": socialToken, "fcmToken": fcmToken],
                    encoding: URLEncoding.queryString)
            } else {
                return .requestParameters(
                    parameters: [ "socialtoken": socialToken],
                    encoding: URLEncoding.queryString)
            }
        }
    }
}
