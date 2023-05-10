//
//  OnboardRequest.swift
//  WAL
//
//  Created by heerucan on 2022/06/26.
//

import Foundation

struct OnboardRequest: Codable {
    let nickname: String
    let categoryTypes: [String]
    let timeTypes: [String]
}
