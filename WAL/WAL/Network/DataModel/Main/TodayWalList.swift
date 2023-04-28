//
//  MainResponse.swift
//  WAL
//
//  Created by 소연 on 2022/07/01.
//

import Foundation

/// [메인화면] 오늘의 왈소리 조회 Response
struct TodayWalList: Codable {
    let todayWal: [TodayWal]
}

struct TodayWal: Codable {
    let id: Int
    let type, content: String
    let canOpen: Bool
    let categoryID: Int
    let isShown: Bool
    let voice: String
    
    enum CodingKeys: String, CodingKey {
        case id, type, content, canOpen
        case categoryID = "categoryId"
        case isShown, voice
    }
}
