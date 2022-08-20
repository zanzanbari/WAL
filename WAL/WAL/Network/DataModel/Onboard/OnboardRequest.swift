//
//  OnboardRequest.swift
//  WAL
//
//  Created by heerucan on 2022/06/26.
//

import Foundation

struct OnboardRequest: Codable {
    let nickname: String
    let dtype: CategoryType
    let time: AlarmTime
    
    init(_ nickname: String, _ dtype: CategoryType, _ time: AlarmTime) {
        self.nickname = nickname
        self.dtype = dtype
        self.time = time
    }
}

// MARK: - DataType

struct CategoryType: Codable {
    let joke, compliment, condolence, scolding: Bool
    
    init(_ joke: Bool, _ compliment: Bool, _ condolence: Bool, _ scolding: Bool) {
        self.joke = joke
        self.compliment = compliment
        self.condolence = condolence
        self.scolding = scolding
    }
}

// MARK: - AlarmTime

struct AlarmTime: Codable {
    let morning, afternoon, night: Bool
    
    init(_ morning: Bool, _ afternoon: Bool, _ night: Bool) {
        self.morning = morning
        self.afternoon = afternoon
        self.night = night
    }
}
