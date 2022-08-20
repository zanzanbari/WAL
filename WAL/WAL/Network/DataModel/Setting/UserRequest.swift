//
//  UserRequest.swift
//  WAL
//
//  Created by heerucan on 2022/08/13.
//

import Foundation

struct UserAlarmRequest: Codable {
    let data: [AlarmTime]
}

struct UserCategoryRequest: Codable {
    let data: [CategoryType]
}
