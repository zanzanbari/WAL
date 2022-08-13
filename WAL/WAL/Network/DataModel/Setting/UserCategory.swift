//
//  UserCategory.swift
//  WAL
//
//  Created by heerucan on 2022/08/13.
//

import Foundation

// MARK: - UserCategory

struct UserCategory: Codable {
    let status: Int
    let message: String
    let data: UserCategoryData
}

struct UserCategoryData: Codable {
    let joke, compliment, condolence, scolding: Bool?
}
