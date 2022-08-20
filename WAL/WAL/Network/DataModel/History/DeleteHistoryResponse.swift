//
//  DeleteHistoryResponse.swift
//  WAL
//
//  Created by 소연 on 2022/06/24.
//

import Foundation

// MARK: - DataClass

struct DeleteHistoryResponse: Codable {
    let postID: Int
    
    enum CodingKeys: String, CodingKey {
        case postID = "postId"
    }
}
