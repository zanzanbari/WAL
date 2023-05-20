//
//  MoyaLoggerPlugin.swift
//  WAL
//
//  Created by heerucan on 2022/05/05.
//

import Foundation

import Moya
import KakaoSDKAuth

final class MoyaLoggerPlugin: PluginType {
    
    // Request를 보낼 때 호출
    func willSend(_ request: RequestType, target: TargetType) {
        guard let httpRequest = request.request else {
            print("--> 유효하지 않은 요청")
            return
        }
        let url = httpRequest.description
        let method = httpRequest.httpMethod ?? "unknown method"
        var log = "====================================================================\n\n1️⃣ [\(method)] \(url)\n\n\n"
        log.append("2️⃣ API: \(target)\n")
        if let headers = httpRequest.allHTTPHeaderFields, !headers.isEmpty {
            log.append("header: \(headers)\n")
        }
        if let body = httpRequest.httpBody, let bodyString = String(bytes: body, encoding: String.Encoding.utf8) {
            log.append("\(bodyString)\n")
        }
        log.append("\n\n============================================= END: \(method) =============================================\n\n")
        print(log)
    }
    
    // Response가 왔을 때
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case let .success(response):
            onSucceed(response)
        case let .failure(error):
            onFail(error)
        }
    }
    
    func onSucceed(_ response: Response) {
        let request = response.request
        let url = request?.url?.absoluteString ?? "nil"
        let statusCode = response.statusCode
        var log = "========================================= 네트워크 통신 성공했는가? =========================================\n"
        log.append("\n3️⃣ [StatusCode: \(statusCode)] \(url)\n\n")
        if let reString = String(bytes: response.data, encoding: String.Encoding.utf8) {
            log.append("4️⃣ Response: \n\(reString)\n")
        }
        guard let accessHeader = response.response?.allHeaderFields["Authorization"] as? String,
              let refreshHeader = response.response?.allHeaderFields["Refresh-Token"] as? String else {
            return
        }
        log.append("5️⃣ Response Header:\n- AccessToken: \(accessHeader) \n\n- RefreshToken: \(refreshHeader)")
        log.append("\n\n============================================= END HTTP =============================================\n\n")
        print(log)
    }
    
    func onFail(_ error: MoyaError) {
        if let response = error.response {
            onSucceed(response)
            return
        }
        print("3️⃣ [실패 StatusCode] : ", error.response?.statusCode)
        var log = "네트워크 오류"
        log.append("<-- \(error.errorCode)\n")
        log.append("\(error.failureReason ?? error.errorDescription ?? "unknown error")\n")
        log.append("<-- END HTTP")
        print(log)
    }
}
