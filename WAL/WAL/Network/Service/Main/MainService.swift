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
}

extension MainService: TargetType {
    
    var path: String {
        switch self {
        case .todayWal:
            return "/today-wal"
        case .openTodayWal(let todayWalId):
            return "/today-wal/\(todayWalId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .todayWal:
            return .get
        case .openTodayWal:
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .todayWal, .openTodayWal:
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
                "Authorization": "Bearer eyJhbGciOiJIUzUxMiJ9.eyJVU0VSX0lEIjoxLCJpYXQiOjE2ODI2MDMzMDMsImV4cCI6MTY4MjY4OTcwM30.kzSEzhx2MYjYSa4pwzaSVZYt4fRVPTL1NrPnmBvf47_OOVsLx0X7EAmKdf_hHbVjclqeECuT0ffdUJO20SWGIw"]
    }
}

