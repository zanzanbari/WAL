//
//  UserInfo.swift
//  WAL
//
//  Created by heerucan on 2022/08/13.
//

import Foundation

// MARK: - UserInfo

struct UserInfo: Codable {
    let status: Int
    let message: String
    let data: UserInfoData?
}

struct UserInfoData: Codable {
    let nickname: String
    let email: String
}
