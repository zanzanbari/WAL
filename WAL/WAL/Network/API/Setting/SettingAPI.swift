//
//  SettingAPI.swift
//  WAL
//
//  Created by heerucan on 2022/08/13.
//

import Foundation

import Moya

final class SettingAPI {
    static let shared = SettingAPI()
    private init() { }
    private let settingProvider = MoyaProvider<SettingService>(plugins: [MoyaLoggerPlugin()])
    
    typealias completion = (UserInfo?, Int?) -> ()
    typealias alarmCompletion = (UserAlarm?, Int?) -> ()
    typealias categoryCompletion = (UserCategory?, Int?) -> ()
    
    typealias defaultCompletion = (DefaultResponse?, Int?) -> ()
    
    private(set) var userInfo: UserInfo?
    private(set) var defaultResponse: DefaultResponse?
    private(set) var alarm: UserAlarm?
    private(set) var category: UserCategory?
    
    // MARK: - GET 유저 닉네임 조회하기
    
    func getUserInfo(completion: @escaping completion) {
        settingProvider.request(.checkNickname) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                do {
                    self.userInfo = try response.map(UserInfo?.self)
                    completion(self.userInfo, response.statusCode)
                } catch(let error) {
                    print("[유저 닉네임 조회] DEBUG: - \(error.localizedDescription)")
                    completion(nil, nil)
                }
                
            case.failure(let error):
                print("[유저 닉네임 조회] DEBUG: - \(error.localizedDescription)")
                completion(nil, error.response?.statusCode)
            }
        }
    }
    
    // MARK: - GET 알림 시간 조회하기
    
    func getAlarm(completion: @escaping alarmCompletion) {
        settingProvider.request(.checkAlarm) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                do {
                    self.alarm = try response.map(UserAlarm?.self)
                    completion(self.alarm, response.statusCode)
                } catch(let error) {
                    print("[알림 시간 조회] DEBUG: - \(error.localizedDescription)")
                    completion(nil, response.statusCode)
                }
                
            case.failure(let error):
                print("[알림 시간 조회] DEBUG: - \(error.localizedDescription)")
                completion(nil, error.response?.statusCode)
            }
        }
    }
    
    // MARK: - GET 카테고리 조회하기
    
    func getCategory(completion: @escaping categoryCompletion) {
        settingProvider.request(.checkCategory) { result in
            switch result {
            case .success(let response):
                do {
                    self.category = try response.map(UserCategory?.self)
                    completion(self.category, response.statusCode)
                } catch(let error) {
                    print("[카테고리 조회] DEBUG: - \(error.localizedDescription)")
                    completion(nil, response.statusCode)
                }
                
            case.failure(let error):
                print("[카테고리 조회] DEBUG: - \(error.localizedDescription)")
                completion(nil, error.response?.statusCode)
            }
        }
    }
    
    // MARK: - POST 유저 닉네임 수정하기
    
    func postUserInfo(nickname: String, completion: @escaping completion) {
        settingProvider.request(.editNickname(nickname)) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                completion(nil, response.statusCode)
                
            case .failure(let error):
                print("[유저 닉네임 수정] DEBUG: - \(error.localizedDescription)")
                completion(nil, error.response?.statusCode)
            }
        }
    }
    
    // MARK: - POST 알림 시간 수정하기
    
    func postAlarm(data: [String], completion: @escaping defaultCompletion) {
        
        let param = UserAlarmRequest(timeTypes: data)
        
        settingProvider.request(.editAlarm(param)) { result in
            switch result {
            case .success(let response):
                completion(nil, response.statusCode)
                
            case.failure(let error):
                print("[알림 시간 수정] DEBUG: - \(error.localizedDescription)")
                completion(nil, error.response?.statusCode)
            }
        }
    }
    
    // MARK: - POST 카테고리 수정하기
    
    func postCategory(data: [String], completion: @escaping categoryCompletion) {
        
        let param = UserCategoryRequest(categoryTypes: data)
        
        settingProvider.request(.editCategory(param)) { result in
            switch result {
            case .success(let response):
                completion(nil, response.statusCode)
                
            case.failure(let error):
                print("[카테고리 수정] DEBUG: - \(error.localizedDescription)")
                completion(nil, error.response?.statusCode)
            }
        }
    }
}
