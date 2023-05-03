//
//  GeneralAPI.swift
//  WAL
//
//  Created by Thisisme Hi on 2022/04/01.
//

import Foundation

struct GeneralAPI {
    private init() { }
    static let baseURL = "http://15.165.167.252/api"
    static let contentType = "application/json"
}

extension GeneralAPI {
    static let version2 = "/v2"
}
