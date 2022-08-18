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
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        nickname = (try? values.decode(String.self, forKey: .nickname)) ?? ""
        email = (try? values.decode(String.self, forKey: .email)) ?? ""
    }
}
