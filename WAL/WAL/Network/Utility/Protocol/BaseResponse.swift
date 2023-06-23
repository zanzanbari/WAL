//
//  BaseResponse.swift
//  WAL
//
//  Created by 소연 on 2023/04/26.
//

import Foundation

/// 상태코드, 오류 메세지 BaseResponse
protocol BaseResponse: Codable {
    var statusCode: Int? { get set }
    var message: String? { get set }
}

extension BaseResponse {
    var statusCase: NetworkResult? {
        return NetworkResult(rawValue: statusCode ?? -999)
    }
}

struct DefaultResponse: BaseResponse {
    var statusCode: Int?
    var message: String?
    var nickname: String?
    
    enum CodingKeys: String, CodingKey {
        case statusCode
        case message
        case nickname
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.statusCode = try container.decodeIfPresent(Int.self, forKey: .statusCode) ?? 0
        self.message = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
        self.nickname = try container.decodeIfPresent(String.self, forKey: .nickname) ?? ""
    }
}
