//
//  ResignRequest.swift
//  WAL
//
//  Created by heerucan on 2022/08/20.
//

import Foundation

// MARK: - ResignRequest

struct ResignRequest: Codable {
    let reason: [String]
    
    init(_ reason: [String]) {
        self.reason = reason
    }
}
