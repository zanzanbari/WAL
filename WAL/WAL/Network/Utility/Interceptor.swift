//
//  TokenInterceptor.swift
//  WAL
//
//  Created by heerucan on 2023/05/08.
//

import Foundation

import Alamofire

final class Interceptor: RequestInterceptor {
    /// adapt : request 전 추가작업을 진행하게 도와주는 함수이나 우리는 필요없음

    /// response에 따라 수행할 작업을 지정 - 통신 실패시 retry 할 수 있음
    func retry(_ request: Request,
               for session: Session,
               dueTo error: Error,
               completion: @escaping (RetryResult) -> Void
    ) {
        guard let statusCode = request.response?.statusCode,
              request.retryCount < 4,
              !(200..<300).contains(statusCode)
        else {
            completion(.doNotRetry)
            return
        }
        
        // 액세스 토큰이 없는 상황 조건 추가
        guard statusCode == 401 else {
            /// 401이 아닌 다른 에러는 retry하지 않고 Error 방출 -> 토큰 만료 이슈가 아니기 때문
            completion(.doNotRetryWithError(error))
            return
        }        
        
        AuthAPI.shared.postReissue { data, status in
            switch data?.statusCode {
            case 200: // 갱신 성공
                completion(.retry)
            default: // 갱신 실패
                completion(.doNotRetryWithError(error))
            }
        }
    }
}
