//
//  ResignRequest.swift
//  WAL
//
//  Created by heerucan on 2022/08/20.
//

import Foundation

// MARK: - ResignRequest

struct ResignRequest: Codable {
    let socialtoken: String
    let data: [String]
    
    init(_ socialtoken: String, _ data: [String]) {
        self.socialtoken = socialtoken
        self.data = data
    }
}
