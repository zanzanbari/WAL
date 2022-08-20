//
//  CreateService.swift
//  WAL
//
//  Created by 배은서 on 2022/07/14.
//

import Moya

enum CreateService {
    case reservedDate
    case reserve(body: Reserve)
}

extension CreateService: BaseTargetType {
    var path: String {
        switch self {
        case.reservedDate:
            return "/reserve/datepicker"
        case .reserve:
            return "/reserve"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .reservedDate: return .get
        case .reserve: return .post
        }
    }
    
    var task: Task {
        switch self {
        case .reservedDate:
            return .requestPlain
        case .reserve(let body):
            return .requestJSONEncodable(body)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json",
                "accesstoken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6OCwibmlja25hbWUiOiLro6jtnawiLCJlbWFpbCI6Imp3eWFuZGtyZ0BrYWthby5jb20iLCJzb2NpYWwiOiJrYWthbyIsImlhdCI6MTY2MDM5MzU1MCwiZXhwIjoxNjYxNjAzMTUwLCJpc3MiOiJjaGFud29vIn0.GetbS7CzKeUaCna4IIi_e2F4p8ZfLukES-N83RoxKKE"]
    }
}
