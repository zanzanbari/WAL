//
//  MainService.swift
//  WAL
//
//  Created by 소연 on 2022/07/01.
//

import Moya

enum MainService {
    case todayWal
    case openTodayWal(todayWalId: Int)
    case subtitle
}

extension MainService: BaseTargetType {
    
    var path: String {
        switch self {
        case .todayWal:
            return "/today-wal"
        case .openTodayWal(let todayWalId):
            return "/today-wal/\(todayWalId)"
        case .subtitle:
            return "/subtitle"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .todayWal, .subtitle:
            return .get
        case .openTodayWal:
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .todayWal, .openTodayWal, .subtitle:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json",
                "Authorization": "Bearer eyJhbGciOiJIUzUxMiJ9.eyJVU0VSX0lEIjoxLCJpYXQiOjE2ODMxMjA1MDEsImV4cCI6MTY4MzIwNjkwMX0.P0Cs02Qms8KWBtzawIWdmAWVMR76QKgV1UJhtjsJtyvoOW3kGdUiUrCqwsuC499Qc-2Dg2vbmHYKs_AzK7sYeg"]
    }
}

