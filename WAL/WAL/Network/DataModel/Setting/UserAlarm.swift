//
//  UserAlarm.swift
//  WAL
//
//  Created by heerucan on 2022/08/13.
//

import Foundation

// MARK: - UserAlarm

struct UserAlarm: BaseResponse, Codable {
    var statusCode: Int?
    var message: String?
    let timeInfo: [String]?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.statusCode = try container.decodeIfPresent(Int.self, forKey: .statusCode) ?? 0
        self.message = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
        self.timeInfo = try container.decodeIfPresent([String].self, forKey: .timeInfo) ?? [""]
    }
}
