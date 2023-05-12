//
//  HistoryResponse.swift
//  WAL
//
//  Created by 소연 on 2022/06/24.
//

import Foundation

// MARK: - HistoryResponse

struct HistoryResponse: BaseResponse, Codable {
    
    var statusCode: Int?
    var message: String?
    
    let notDoneData, doneData: [HistoryData]?
    
    var statusCase: NetworkResult? {
        return NetworkResult(rawValue: statusCode ?? -999)
    }
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

/// 왈소리 조회 상태 (사용자가 보았는지)
enum HistoryWalShowStatus: String {
    case open     = "OPEN"
    case closed   = "CLOSED"
    
    var status: Bool {
        switch self {
        case .open:      return true
        case .closed:    return false
        }
    }
}
