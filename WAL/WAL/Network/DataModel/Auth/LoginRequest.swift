//
//  LoginRequest.swift
//  WAL
//
//  Created by heerucan on 2023/05/05.
//

import Foundation

// MARK: - LoginRequest

struct LoginRequest: Codable {
    let socialToken: String
    let socialType: String
    let fcmToken: String
    
    init(_ socialToken: String, _ socialType: String, _ fcmToken: String) {
        self.socialToken = socialToken
        self.socialType = socialType
        self.fcmToken = fcmToken
    }
}
