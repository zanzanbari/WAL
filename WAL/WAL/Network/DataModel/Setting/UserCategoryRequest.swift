//
//  UserCategoryRequest.swift
//  WAL
//
//  Created by heerucan on 2022/08/13.
//

import Foundation

struct UserCategoryRequest: Codable {
    let dtype: [Dtype]
}

// MARK: - Datum
struct Dtype: Codable {
    let joke, compliment, condolence, scolding: Bool
    
    init(_ joke: Bool, _ compliment: Bool, _ condolence: Bool, _ scolding: Bool) {
        self.joke = joke
        self.compliment = compliment
        self.condolence = condolence
        self.scolding = scolding
    }
}
