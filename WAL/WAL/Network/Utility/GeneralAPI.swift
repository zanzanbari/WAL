//
//  GeneralAPI.swift
//  WAL
//
//  Created by Thisisme Hi on 2022/04/01.
//

import Foundation

struct GeneralAPI {
    private init() { }
    static let baseURL = "http://15.165.74.139:8080/api/v1"
    static let contentType = "application/json"
    
    static let accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Mywibmlja25hbWUiOiLsnbTspIAiLCJlbWFpbCI6ImNob2k5OTA0MDZAbmF2ZXIuY29tIiwic29jaWFsIjoia2FrYW8iLCJpYXQiOjE2NjA5NzYwMzcsImV4cCI6MTY2MjE4NTYzNywiaXNzIjoiY2hhbndvbyJ9.uC4Wuaz89jUEiCF1_B7HZQ6fOFq2Gkn0byrJZ9q16gw"
    static let refreshToken = UserDefaults.standard.string(forKey: Constant.Key.refreshToken) ?? ""
    static let socialToken = UserDefaults.standard.string(forKey: Constant.Key.socialToken) ?? ""
    static let socialLogin = UserDefaults.standard.string(forKey: Constant.Key.socialLogin) ?? ""
}
