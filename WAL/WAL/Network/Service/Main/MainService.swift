//
//  MainService.swift
//  WAL
//
//  Created by 소연 on 2022/07/01.
//

import Moya

enum MainService {
    case main
    case mainItem(param: Int)
}

extension MainService: TargetType {
    
    var path: String {
        switch self {
        case .main:
            return "/main"
        case .mainItem(let param):
            return "/main/\(param)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .main:
            return .get
        case .mainItem:
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .main, .mainItem:
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
                "accesstoken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwibmlja25hbWUiOm51bGwsImVtYWlsIjoiYWxpY2U5ODA5QG5hdmVyLmNvbSIsInNvY2lhbCI6Imtha2FvIiwiaWF0IjoxNjYwOTc2MjE3LCJleHAiOjE2NjIxODU4MTcsImlzcyI6ImNoYW53b28ifQ.0ns-g7RiESPXdM9AxMwM1X99a3qOwSS0E-c_DpWyeDQ"]
        // -> 소연 토큰
    }
}

