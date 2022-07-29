//
//  MainService.swift
//  WAL
//
//  Created by 소연 on 2022/07/01.
//

import Moya

enum MainService {
    case main
}

extension MainService: TargetType {
    
    var path: String {
        switch self {
        case .main:
            return "/main"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .main:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .main:
            return .requestPlain
        }
    }
    
    var baseURL: URL {
        return URL(string: GeneralAPI.baseURL)!
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json",
                "accesstoken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwibmlja25hbWUiOiLsmYjrv6EiLCJlbWFpbCI6ImNob2N3MDQwMkBnbWFpbC5jb20iLCJzb2NpYWwiOiJrYWthbyIsImlhdCI6MTY1NjY1MTk2OSwiZXhwIjoxNjU3ODYxNTY5LCJpc3MiOiJjaGFud29vIn0.YGNGe26Zyw0eLotooipPLfFkYYzaHUxJ7QA9yliPvT8"]
    }
}

