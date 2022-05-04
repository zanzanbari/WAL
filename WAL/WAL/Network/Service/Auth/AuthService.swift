//
//  TempService.swift
//  WAL
//
//  Created by Thisisme Hi on 2022/04/01.
//

import Moya

enum AuthService {
    case social(social: String, token: String, fcmToken: String?)
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
        case .social(_, let token, let fcmToken):
            if let fcmToken = fcmToken {
                return .requestParameters(
                    parameters: [
                        "token": token,
                        "fcmToken": fcmToken],
                    encoding: URLEncoding.queryString)
            } else {
                return .requestParameters(
                    parameters: [
                        "token": token],
                    encoding: URLEncoding.queryString)
            }
        }
    }
}
