//
//  MainSubtitle.swift
//  WAL
//
//  Created by 소연 on 2023/05/03.
//

import Foundation

/// 오늘의 왈소리 목록 (메인화면 진입 시 Response)
struct MainSubtitle: BaseResponse, Codable {
    
    var statusCode: Int?
    var message: String?
    
    let todaySubtitle: String?
    
    var statusCase: NetworkResult? {
        return NetworkResult(rawValue: statusCode ?? -999)
    }
    
    enum CodingKeys: String, CodingKey {
        case statusCode
        case message
        case todaySubtitle
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.statusCode = try container.decodeIfPresent(Int.self, forKey: .statusCode) ?? 0
        self.message = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
        self.todaySubtitle = try container.decodeIfPresent(String.self, forKey: .todaySubtitle) ?? ""
    }
    
}
