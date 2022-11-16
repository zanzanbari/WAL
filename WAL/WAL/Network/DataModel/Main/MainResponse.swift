//
//  MainResponse.swift
//  WAL
//
//  Created by 소연 on 2022/07/01.
//

import Foundation

// MARK: - Main Response

struct MainResponse: Codable {
    let subtitle: String
    let todayWal: [TodayWal]
}

// MARK: - Today Wal

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
