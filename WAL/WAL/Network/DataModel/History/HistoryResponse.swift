//
//  HistoryResponse.swift
//  WAL
//
//  Created by 소연 on 2022/06/24.
//

import Foundation

// MARK: - HistoryResponse

struct HistoryResponse: Codable {
    let sendingData, completeData: [HistoryData]
}

// MARK: - Datum

struct HistoryData: Codable {
    let postID: Int
    let sendingDate, content, reserveAt, sendDueDate: String
    let hidden: Bool?
    
    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case sendingDate, content, reserveAt, sendDueDate, hidden
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        postID = (try? values.decode(Int.self, forKey: .postID)) ?? 0
        sendingDate = (try? values.decode(String.self, forKey: .sendingDate)) ?? ""
        content = (try? values.decode(String.self, forKey: .content)) ?? ""
        reserveAt = (try? values.decode(String.self, forKey: .reserveAt)) ?? ""
        sendDueDate = (try? values.decode(String.self, forKey: .sendDueDate)) ?? ""
        hidden = (try? values.decode(Bool.self, forKey: .hidden)) ?? false
    }
}
