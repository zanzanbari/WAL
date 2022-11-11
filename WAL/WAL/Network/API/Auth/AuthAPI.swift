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
    private let authProvider = MoyaProvider<AuthService>(plugins: [MoyaLoggerPlugin()])
    private init() { }
    
    private(set) var loginData: GenericResponse<Login>?
    private(set) var logoutData: GenericResponse<Logout>?
    private(set) var reissueData: GenericResponse<Reissue>?
    
    // MARK: - POST 소셜로그인
    
    func postSocialLogin(social: String,
                         socialtoken: String,
                         fcmtoken: String?,
                         completion: @escaping ((GenericResponse<Login>?, Int?) -> ())) {
        
        authProvider.request(.social(social: social,
                                     socialtoken: socialtoken,
                                     fcmtoken: fcmtoken)) { result in
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
    
    func getLogout(completion: @escaping ((GenericResponse<Logout>?, Int?) -> ())) {
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
        
    func postResign(social: String,
                    data: [String],
                    socialtoken: String,
                    completion: @escaping ((GenericResponse<Logout>?, Int?) -> ())) {
       
        let reason = ResignRequest.init(socialtoken, data)
        
        authProvider.request(.resign(social: social,
                                     param: reason)) { result in
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
    
    // MARK: - POST 토큰 재발급
    
    func postReissue(completion: @escaping ((GenericResponse<Reissue>?, Int?) -> ())) {
        authProvider.request(.reissue) { result in
            switch result {
            case .success(let response):
                do {
                    self.reissueData = try response.map(GenericResponse<Reissue>?.self)
                    guard let reissueData = self.reissueData else { return }
                    completion(reissueData, nil)
                    
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
