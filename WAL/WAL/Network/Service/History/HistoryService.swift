//
//  HistoryService.swift
//  WAL
//
//  Created by 소연 on 2022/06/24.
//

import Moya

enum HistoryService {
    case history
    case cancelReserve(postId: Int)
    case deleteReserve(postId: Int)
}

extension HistoryService: BaseTargetType {
    var path: String {
        switch self {
        case.history:
            return "/reservation/history"
        case .cancelReserve(let postId):
            return "/reservation/\(postId)/cancel"
        case .deleteReserve(let postId):
            return "/reservation/history/\(postId)/remove"
        }
    }
    
    var method: Method {
        switch self {
        case .history:
            return .get
        case .cancelReserve:
            return .post
        case .deleteReserve:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .history, .cancelReserve, .deleteReserve:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json",
                "Authorization": UserDefaultsHelper.standard.accesstoken ?? ""]
    }
}
