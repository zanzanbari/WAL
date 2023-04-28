//
//  BaseResponse.swift
//  WAL
//
//  Created by 소연 on 2023/04/26.
//

import Foundation

/// 객체로 응답이 올 때
struct BaseResponse<T: Decodable>: Decodable {
    
    /// 상태코드
    var statusCode: Int?
    /// 오류 메세지
    var message: String?
    /// Response Data (객체)
    var data: T? 
    
    var statusCase: NetworkResult? {
        guard let _statusCode = statusCode else { return nil }
        return NetworkResult(rawValue: _statusCode)
    }
    
    enum CodingKeys: String, CodingKey {
        case statusCode
        case message
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        statusCode = try container.decodeIfPresent(Int.self, forKey: .statusCode)
        message = try container.decodeIfPresent(String.self, forKey: .message)
        data = try container.decodeIfPresent(T.self, forKey: .data)
    }
}

/// 객체 배열로 응답이 올 때
struct BaseArrayResponse<T: Decodable>: Decodable {
    
    /// 상태코드
    let statusCode: Int?
    /// 오류 메세지
    let message: String?
    /// Response Data (배열)
    let data: [T]?
    
    var statusCase: NetworkResult? {
        guard let _statusCode = statusCode else { return nil }
        return NetworkResult(rawValue: _statusCode)
    }
    
    enum CodingKeys: String, CodingKey {
        case statusCode
        case message
        case data
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        statusCode = try container.decodeIfPresent(Int.self, forKey: .statusCode)
        message = try container.decodeIfPresent(String.self, forKey: .message)
        data = try container.decodeIfPresent([T].self, forKey: .data)
    }
    
}
