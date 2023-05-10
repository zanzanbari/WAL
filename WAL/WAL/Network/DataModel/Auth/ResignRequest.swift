//
//  ResignRequest.swift
//  WAL
//
//  Created by heerucan on 2022/08/20.
//

import Foundation

// MARK: - ResignRequest

struct ResignRequest: Codable {
    let reasons: [String]
    
    init(reasons: [String]) {
        self.reasons = reasons
    }
}
