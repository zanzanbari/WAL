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
    case reissue
    case resign(social: String, param: ResignRequest)
}

extension AuthService: BaseTargetType {
    
    var path: String {
        switch self {
        case .social(let social, _, _): return "/auth/\(social)/login"
        case .logout: return "/auth/logout"
        case .reissue: return "/auth/reissue/token"
        case .resign(let social, _): return "/auth/\(social)/logout"
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
                    parameters: ["socialtoken": socialToken,
                                 "fcmToken": fcmToken],
                    encoding: URLEncoding.queryString)
            } else {
                return .requestParameters(
                    parameters: ["socialtoken": socialToken],
                    encoding: URLEncoding.queryString)
            }
        case .logout, .reissue: return .requestPlain
        case .resign(_, let param):
            return .requestJSONEncodable(param)
        }
        
    }
    
    var headers: [String : String]? {
        switch self {
        case .reissue:
            return ["Content-Type": GeneralAPI.contentType,
                    "accesstoken": GeneralAPI.accessToken,
                    "refreshtoken": GeneralAPI.refreshToken]
        default:
            return ["Content-Type": GeneralAPI.contentType,
                    "accesstoken": UserDefaults.standard.string(forKey: Constant.Key.accessToken) ?? ""]
            
        }
    }
}
