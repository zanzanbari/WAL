//
//  NetworkResult.swift
//  WAL
//
//  Created by Thisisme Hi on 2022/04/01.
//

import Foundation

enum NetworkResult: Int {
    case none                   = -999
    
    /// 상태코드 200
    case okay                   = 200
    /// 상태코드 201
    case created                = 201
    /// 상태코드 204
    case noContent              = 204
    /// 상태코드 400
    case badRequest             = 400
    /// 상태코드 401 
    case unAuthorized           = 401
    /// 상태코드 402
    case nullValue              = 402
    /// 상태코드 403
    case forbidden              = 403
    /// 상태코드 404
    case notFound               = 404
    /// 상태코드 409
    case conflict               = 409
    /// 상태코드 500
    case internalServerError    = 500
    /// 상태코드 503
    case serviceUnavailable     = 503
    /// 상태코드 600
    case dbError                = 600
}
