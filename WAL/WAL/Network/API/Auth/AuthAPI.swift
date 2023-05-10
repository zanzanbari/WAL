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
    private lazy var authProvider = MoyaProvider<AuthService>(
        session: Session(interceptor: Interceptor()),
        plugins: [MoyaLoggerPlugin()]
    )

    typealias completion = (DefaultResponse?, Int?) -> ()
    
    private(set) var defaultData: DefaultResponse?
    
    // MARK: - POST 소셜로그인
    
    func postLogin(param: LoginRequest, completion: @escaping completion) {
        
        let param = LoginRequest(param.socialToken, param.socialType, param.fcmToken)
        
        authProvider.request(.login(param: param)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 || response.statusCode == 201 {
                    guard let accessHeader = response.response?.allHeaderFields[GeneralAPI.authentication] as? String,
                          let refreshHeader = response.response?.allHeaderFields[GeneralAPI.refreshToken] as? String else {
                        completion(nil, nil)
                        return
                    }
                    let accessToken = String(accessHeader.dropFirst("".count))
                    let refreshToken = String(refreshHeader.dropFirst("".count))
                    UserDefaultsHelper.standard.accesstoken = accessToken
                    UserDefaultsHelper.standard.refreshtoken = refreshToken
                    completion(nil, nil)
                    
                } else {
                    do {
                        let loginData = try response.map(DefaultResponse.self)
                        completion(loginData, nil)
                    } catch {
                        completion(nil, 500)
                    }
                }
            case .failure:
                completion(nil, 500)
            }
        }
    }
    
    // MARK: - POST 회원탈퇴
    
    func postResign(param: ResignRequest, completion: @escaping completion) {
        
        let param = ResignRequest(reasons: param.reasons)
        
        authProvider.request(.resign(param: param)) { result in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 204:
                    completion(nil, 204)
                case 300...500:
                    do {
                        let defaultData = try response.map(DefaultResponse?.self)
                        completion(defaultData, nil)
                    } catch {
                        print(error.localizedDescription)
                        completion(nil, 500)
                    }
                default:
                    completion(nil, response.statusCode)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil, 500)
            }
        }
    }
    
    // MARK: - POST 토큰 재발급
    
    func postReissue(completion: @escaping completion) {
        authProvider.request(.reissue) { result in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200:
                    guard let accessHeader = response.response?.allHeaderFields[GeneralAPI.authentication] as? String else {
                        completion(nil, nil)
                        return
                    }
                    let accessToken = String(accessHeader.dropFirst("".count))
                    UserDefaultsHelper.standard.accesstoken = accessToken
                    completion(nil, nil)
                default:
                    do {
                        let reissueData = try response.map(DefaultResponse.self)
                        completion(reissueData, nil)
                    } catch {
                        completion(nil, 500)
                    }
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil, 500)
            }
        }
    }
}
