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
    
    // MARK: - Auth 관련 데이터 저장
    static let accessToken = UserDefaults.standard.string(forKey: Constant.Key.accessToken)!
    static let refreshToken = UserDefaults.standard.string(forKey: Constant.Key.refreshToken)!
    static let socialToken = UserDefaults.standard.string(forKey: Constant.Key.socialToken)!
    static let socialLogin = UserDefaults.standard.string(forKey: Constant.Key.socialLogin)!
}
