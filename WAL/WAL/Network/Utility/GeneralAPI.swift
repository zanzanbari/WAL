//
//  GeneralAPI.swift
//  WAL
//
//  Created by Thisisme Hi on 2022/04/01.
//

import Foundation

struct GeneralAPI {
    static let baseURL = "http://15.165.74.139:8080/api/v1"
    static let contentType = "application/json"
    static let accessToken = UserDefaults.standard.string(forKey: "accessToken")
    static let socialToken = UserDefaults.standard.string(forKey: "socialToken")
    static let socialLogin = UserDefaults.standard.string(forKey: "socialLogin")
}
