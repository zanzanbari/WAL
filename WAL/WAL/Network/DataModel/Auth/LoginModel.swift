//
//  LoginModel.swift
//  WAL
//
//  Created by heerucan on 2022/08/15.
//

import Foundation

// MARK: - Login

struct Login: Codable {
    let nickname: String?
    let accesstoken, refreshtoken: String
}
