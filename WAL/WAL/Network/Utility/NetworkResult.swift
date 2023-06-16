//
//  NetworkResult.swift
//  WAL
//
//  Created by Thisisme Hi on 2022/04/01.
//

import Foundation

enum NetworkResult: Int {
    case none                   = -999
    
    /// 성공 200
    case okay                   = 200
    /// 생성 201
    case created                = 201
    /// 204
    case noContent              = 204
    /// 400
    case badRequest             = 400
    /// 401 (토큰만료)
    case unAuthorized           = 401
    /// 402
    case nullValue              = 402
    /// 403
    case forbidden              = 403
    /// 404 (User X)
    case notFound               = 404
    /// 409
    case conflict               = 409
    /// 5000
    case internalServerError    = 500
    /// 503
    case serviceUnavailable     = 503
    /// 600
    case dbError                = 600
}
