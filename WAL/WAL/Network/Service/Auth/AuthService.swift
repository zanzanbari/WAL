//
//  AuthService.swift
//  WAL
//
//  Created by Thisisme Hi on 2022/04/01.
//

import Moya

enum AuthService {
    case social(social: String, socialToken: String, fcmToken: String?)
    case logout
//    case reissue
    case resign(social: String, socialToken: String)
}

extension AuthService: BaseTargetType {
    
    var path: String {
        switch self {
        case .social(let social, _, _): return "/auth/\(social)/login"
        case .logout: return "/auth/logout"
        case .resign(let social, _): return "/auth/v1/\(social)/resign"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .logout: return .get
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
        case .logout: return .requestPlain
        case .resign(_, let socialToken):
            return .requestParameters(
                parameters: [ "socialtoken": socialToken],
                encoding: URLEncoding.queryString)
        }
    }
}
