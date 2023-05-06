//
//  AuthService.swift
//  WAL
//
//  Created by Thisisme Hi on 2022/04/01.
//

import Moya

enum AuthService {
    case login(param: LoginRequest)
    case reissue
    case resign(param: ResignRequest)
}

extension AuthService: BaseTargetType {
    
    var path: String {
        switch self {
        case .login: return "/auth/login"
        case .reissue: return "/auth/reissue"
        case .resign: return "/user/me/resign"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default: return .post
        }
    }
    
    var task: Task {
        switch self {
        case .login(let param):
            return .requestJSONEncodable(param)
        case .reissue:
            return .requestPlain
        case .resign(let param):
            return .requestJSONEncodable(param)
        }
        
    }
    
    var headers: [String: String]? {
        switch self {
        case .login:
            return ["Content-Type": GeneralAPI.contentType]
        case .reissue:
            return ["Content-Type": GeneralAPI.contentType,
                    "Refresh-Token": UserDefaultsHelper.standard.refreshtoken ?? ""]
        default:
            return ["Content-Type": GeneralAPI.contentType,
                    "Authorization": UserDefaultsHelper.standard.accesstoken ?? ""]
        }
    }
}
