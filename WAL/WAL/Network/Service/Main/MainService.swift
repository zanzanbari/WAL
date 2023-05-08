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

extension MainService: BaseTargetType {
    
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
    
    var headers: [String : String]? {
        return [GeneralAPI.contentType: GeneralAPI.json,
                GeneralAPI.authentication: UserDefaultsHelper.standard.accesstoken ?? ""]
    }
}
