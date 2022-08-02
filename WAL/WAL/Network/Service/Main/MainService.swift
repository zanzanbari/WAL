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
                "accesstoken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwibmlja25hbWUiOiLsmYjrv6EiLCJlbWFpbCI6ImNob2N3MDQwMkBnbWFpbC5jb20iLCJzb2NpYWwiOiJrYWthbyIsImlhdCI6MTY1OTA5MjYyNiwiZXhwIjoxNjYwMzAyMjI2LCJpc3MiOiJjaGFud29vIn0.MOmYnBunDTrKXOl7eiI7AICcl8sgrS63m6wCH_dA8Vc"]
    }
}

