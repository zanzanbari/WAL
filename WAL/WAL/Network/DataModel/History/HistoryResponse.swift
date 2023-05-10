//
//  HistoryResponse.swift
//  WAL
//
//  Created by 소연 on 2022/06/24.
//

import Foundation

// MARK: - HistoryResponse

struct HistoryResponse: Codable {
    let notDoneData, doneData: [HistoryData]
}

// MARK: - Datum

struct HistoryData: Codable {
    let reservationID: Int
    let message, detail, showStatus, reservedAt: String
    
    enum CodingKeys: String, CodingKey {
        case reservationID = "reservationId"
        case message, detail, showStatus, reservedAt
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        reservationID = (try? values.decode(Int.self, forKey: .reservationID)) ?? 0
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
        detail = (try? values.decode(String.self, forKey: .detail)) ?? ""
        showStatus = (try? values.decode(String.self, forKey: .showStatus)) ?? ""
        reservedAt = (try? values.decode(String.self, forKey: .reservedAt)) ?? ""
    }
}
