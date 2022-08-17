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

extension HistoryService: TargetType {
    var path: String {
        switch self {
        case.history:
            return "/reserve"
        case .cancelReserve(let postId):
            return "/reserve/\(postId)"
        case .deleteReserve(let postId):
            return "/reserve/completed/\(postId)"
        }
    }
    
    var method: Method {
        switch self {
        case .history:
            return .get
        case .cancelReserve, .deleteReserve:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .history, .cancelReserve, .deleteReserve:
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
                "accesstoken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjQsIm5pY2tuYW1lIjoiSEVFUlVDQU4iLCJlbWFpbCI6Imp3eWFuZGtyZ0BrYWthby5jb20iLCJzb2NpYWwiOiJrYWthbyIsImlhdCI6MTY2MDc0NDM4MSwiZXhwIjoxNjYxOTUzOTgxLCJpc3MiOiJjaGFud29vIn0.q_z4ZZCA5ECD5ydcGdYrtmZP2PSIraZxpMZURWbhw4Q"]
    }
}
