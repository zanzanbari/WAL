//
//  AuthService.swift
//  WAL
//
//  Created by Thisisme Hi on 2022/04/01.
//

import Moya

enum AuthService {
    case login(param: LoginRequest)
    case logout
    case reissue
    case resign(social: String, param: ResignRequest)
}

extension AuthService: BaseTargetType {
    
    var path: String {
        switch self {
        case .login: return "/auth/login"
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
        case .login(let param):
            return .requestJSONEncodable(param)
        case .logout, .reissue:
            return .requestPlain
        case .resign(_, let param):
            return .requestJSONEncodable(param)
        }
        
    }
    
    var headers: [String: String]? {
        switch self {
        case .login:
            return ["Content-Type": GeneralAPI.contentType]
        case .reissue:
            return ["Content-Type": GeneralAPI.contentType,
                    "accesstoken": UserDefaultsHelper.standard.accesstoken ?? "",
                    "refreshtoken": UserDefaultsHelper.standard.refreshtoken ?? ""]
        default:
            return ["Content-Type": GeneralAPI.contentType,
                    "accesstoken": UserDefaultsHelper.standard.accesstoken ?? ""]
        }
    }
}
