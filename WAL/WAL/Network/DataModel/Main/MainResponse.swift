//
//  MainResponse.swift
//  WAL
//
//  Created by 소연 on 2022/07/01.
//

import Foundation

// MARK: - MainResponse

struct MainResponse: Codable {
    let id: Int
    let type, content: String
    let canOpen: Bool
    let categoryId: Int
    let isShown: Bool
    let voice: String

    enum CodingKeys: String, CodingKey {
        case id, type, content, canOpen
        case categoryId
        case isShown, voice
    }
}
