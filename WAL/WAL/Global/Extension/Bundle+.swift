//
//  Bundle+.swift
//  WAL
//
//  Created by heerucan on 2022/05/09.
//

import Foundation

extension Bundle {
    var apiKey: String {
        guard let file = path(forResource: "KeyInfo", ofType: "plist") else { return "" }
        
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["API_KEY"] as? String else { fatalError("KeyInfo.plist에 API_KEY를 설정해주세요.") }
        return key
    }
}
