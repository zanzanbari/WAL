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
            return "/reservation/calender"
        case .reserve:
            return "/reservation/register"
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
        return [GeneralAPI.contentType: GeneralAPI.json,
                GeneralAPI.authentication: UserDefaultsHelper.standard.accesstoken ?? ""]
    }
}
