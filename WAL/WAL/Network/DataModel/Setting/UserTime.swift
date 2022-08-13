//
//  UserTime.swift
//  WAL
//
//  Created by heerucan on 2022/08/13.
//

import Foundation

// MARK: - UserTime

struct UserTime: Codable {
    let status: Int
    let message: String
    let data: UserTimeData
}

struct UserTimeData: Codable {
    let morning, afternoon, night: Bool?
}
