//
//  BaseResponse.swift
//  WAL
//
//  Created by 소연 on 2023/04/26.
//

import Foundation

/// 상태코드, 오류 메세지 BaseResponse
protocol BaseResponse {
    var statusCode: Int? { get set }
    var message: String? { get set }
}
