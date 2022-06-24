//
//  HistoryService.swift
//  WAL
//
//  Created by 소연 on 2022/06/24.
//

import Moya

enum HistoryService {
    case history
}

extension HistoryService: TargetType {
    var path: String {
        switch self {
        case.history:
            return "/reserve"
        }
    }
    
    var method: Method {
        switch self {
        case .history:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .history:
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
                "accesstoken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwibmlja25hbWUiOiLsmYjrv6HsnbQiLCJlbWFpbCI6ImNob2N3MDQwMkBnbWFpbC5jb20iLCJzb2NpYWwiOiJrYWthbyIsImlhdCI6MTY1NTI4MjQxOCwiZXhwIjoxNjU2NDkyMDE4LCJpc3MiOiJjaGFud29vIn0._cXBIIPP4uFCH1XIG6Mqlgswh1pa19kqd0KafF2B7Qc"]
    }
}
