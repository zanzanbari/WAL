//
//  AuthAPI.swift
//  WAL
//
//  Created by Thisisme Hi on 2022/04/01.
//

import Foundation

import Moya
import KakaoSDKAuth

final class AuthAPI {
    static let shared = AuthAPI()
    private init() { }
    private lazy var authProvider = MoyaProvider<AuthService>(plugins: [MoyaLoggerPlugin()])

    typealias completion = (DefaultResponse?, Int?) -> ()
    
    private(set) var defaultData: DefaultResponse?
    
    // MARK: - POST 소셜로그인
    
    func postLogin(param: LoginRequest, completion: @escaping completion) {
        
        let param = LoginRequest(param.socialToken, param.socialType, param.fcmToken)
        
        authProvider.request(.login(param: param)) { result in
            switch result {
            case .success(let response):
                guard let accessHeader = response.response?.allHeaderFields[GeneralAPI.authentication] as? String,
                      let refreshHeader = response.response?.allHeaderFields[GeneralAPI.refreshToken] as? String else {
                    completion(nil, response.statusCode)
                    return
                }
                
                let accessToken = String(accessHeader.dropFirst("".count))
                let refreshToken = String(refreshHeader.dropFirst("".count))
                UserDefaultsHelper.standard.accesstoken = accessToken
                UserDefaultsHelper.standard.refreshtoken = refreshToken
                completion(nil, response.statusCode)
                
            case .failure(let error):
                print("[소셜로그인] DEBUG: - \(error.localizedDescription)")
                completion(nil, error.response?.statusCode)
            }
        }
    }
    
    // MARK: - POST 회원탈퇴
    
    func postResign(param: ResignRequest, completion: @escaping completion) {
        
        let param = ResignRequest(reasons: param.reasons)
        
        authProvider.request(.resign(param: param)) { result in
            switch result {
            case .success(let response):
                completion(nil, response.statusCode)
            case .failure(let error):
                print("[회원탈퇴] DEBUG: - \(error.localizedDescription)")
                completion(nil, error.response?.statusCode)
            }
        }
    }
    
    // MARK: - POST 토큰 재발급
    
    func postReissue(completion: @escaping completion) {
        authProvider.request(.reissue) { result in
            switch result {
            case .success(let response):
                
                guard let accessHeader = response.response?.allHeaderFields[GeneralAPI.authentication] as? String else {
                    completion(nil, response.statusCode)
                    return
                }
                
                let accessToken = String(accessHeader.dropFirst("".count))
                UserDefaultsHelper.standard.accesstoken = accessToken
                completion(nil, response.statusCode)
                
            case .failure(let error):
                print("[토큰 재발급] DEBUG: - \(error.localizedDescription)")
                completion(nil, error.response?.statusCode)
            }
        }
    }
}
