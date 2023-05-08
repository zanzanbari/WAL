//
//  BaseTargetType.swift
//  WAL
//
//  Created by heerucan on 2022/05/05.
//

import Foundation

import Moya

protocol BaseTargetType: TargetType { }

extension BaseTargetType {
    var baseURL: URL {
        return URL(string: GeneralAPI.baseURL + GeneralAPI.version2)!
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
    
    var headers: [String : String]? {
        return [GeneralAPI.contentType: GeneralAPI.json,
                GeneralAPI.authentication: UserDefaultsHelper.standard.accesstoken ?? ""]
    }
}

