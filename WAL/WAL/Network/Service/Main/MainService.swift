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
                "accesstoken": UserDefaults.standard.string(forKey: Constant.Key.accessToken) ?? ""]
    }
}

