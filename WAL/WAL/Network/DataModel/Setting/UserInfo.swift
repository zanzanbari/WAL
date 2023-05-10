//
//  UserInfo.swift
//  WAL
//
//  Created by heerucan on 2022/08/13.
//

import Foundation

// MARK: - UserInfo

struct UserInfo: BaseResponse, Codable {
    var statusCode: Int?
    var message: String?
    let nickname: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.statusCode = try container.decodeIfPresent(Int.self, forKey: .statusCode) ?? 0
        self.message = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
        self.nickname = try container.decodeIfPresent(String.self, forKey: .nickname) ?? ""
    }
}
