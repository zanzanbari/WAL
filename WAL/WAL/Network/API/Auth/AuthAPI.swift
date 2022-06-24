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
    static let shared: AuthAPI = AuthAPI()
    private let authProvider = MoyaProvider<AuthService>(plugins: [MoyaLoggerPlugin()])
    private init() { }
    
    public private(set) var loginData: GenericResponse<Login>?
    public private(set) var logoutData: GenericResponse<Logout>?
    
    // MARK: - POST 소셜로그인
    
    public func postSocialLogin(social: String, socialToken: String, fcmToken: String?,
                                completion: @escaping ((GenericResponse<Login>?, Int?) -> ())) {
        
        authProvider.request(.social(social: social, socialToken: socialToken, fcmToken: fcmToken)) { result in
            switch result {
            case .success(let response):
                do {
                    self.loginData = try response.map(GenericResponse<Login>?.self)
                    guard let loginData = self.loginData else { return }
                    completion(loginData, nil)
                    
                } catch(let err) {
                    print(err.localizedDescription, 500)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil, 500)
            }
        }
    }
    
    // MARK: - GET 로그아웃
    
    public func getLogout(completion: @escaping ((GenericResponse<Logout>?, Int?) -> ())) {
        authProvider.request(.logout) { result in
            switch result {
            case .success(let response):
                do {
                    self.logoutData = try response.map(GenericResponse<Logout>?.self)
                    guard let logoutData = self.logoutData else { return }
                    completion(logoutData, nil)
                    
                } catch(let err) {
                    print(err.localizedDescription, 500)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil, 500)
            }
        }
    }
    
    // MARK: - POST 회원탈퇴
        
    public func postResign(social: String, socialToken: String,
                           completion: @escaping ((GenericResponse<Logout>?, Int?) -> ())) {
        authProvider.request(.resign(social: social, socialToken: socialToken)) { result in
            switch result {
            case .success(let response):
                do {
                    self.logoutData = try response.map(GenericResponse<Logout>?.self)
                    guard let logoutData = self.logoutData else { return }
                    completion(logoutData, nil)
                    
                } catch(let err) {
                    print(err.localizedDescription, 500)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil, 500)
            }
        }
    }
}
