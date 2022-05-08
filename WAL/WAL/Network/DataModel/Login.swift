//
//  Login.swift
//  WAL
//
//  Created by Thisisme Hi on 2022/04/01.
//

import Foundation

// MARK: - Login

struct Login: Codable {
    let nickname: String?
    let accesstoken, refreshtoken: String
}
