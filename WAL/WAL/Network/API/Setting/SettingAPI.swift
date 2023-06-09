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
    private let settingProvider = MoyaProvider<SettingService>(
//        session: Session(interceptor: Interceptor()),
        plugins: [MoyaLoggerPlugin()]
    )
    
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
                    print(error.localizedDescription)
                }
                
            case.failure(let error):
                print(error.localizedDescription)
                completion(nil, 500)
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
                    print(error.localizedDescription)
                    completion(nil, response.statusCode)
                }
                
            case.failure(let error):
                print(error.localizedDescription)
                completion(nil, 500)
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
                    print(error.localizedDescription)
                }
                
            case.failure(let error):
                print(error.localizedDescription)
                completion(nil, 500)
            }
        }
    }
    
    // MARK: - POST 유저 닉네임 수정하기
    
    func postUserInfo(nickname: String, completion: @escaping completion) {
        settingProvider.request(.editNickname(nickname)) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 204:
                    completion(nil, 204)
                case 300...500:
                    do {
                        self.userInfo = try response.map(UserInfo.self)
                        completion(self.userInfo, nil)
                    } catch {
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
    
    // MARK: - POST 알림 시간 수정하기
    
    func postAlarm(data: [String], completion: @escaping defaultCompletion) {
        
        let param = UserAlarmRequest(timeTypes: data)
        
        settingProvider.request(.editAlarm(param)) { result in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 204:
                    completion(nil, 204)
                case 300...500:
                    do {
                        self.defaultResponse = try response.map(DefaultResponse?.self)
                        completion(self.defaultResponse, nil)
                    } catch(let error) {
                        print(error.localizedDescription)
                        completion(nil, 500)
                    }
                default:
                    completion(nil, response.statusCode)
                }
                
            case.failure(let error):
                print(error.localizedDescription)
                completion(nil, 500)
            }
        }
    }
    
    // MARK: - POST 카테고리 수정하기
    
    func postCategory(data: [String], completion: @escaping categoryCompletion) {
        
        let param = UserCategoryRequest(categoryTypes: data)
        
        settingProvider.request(.editCategory(param)) { result in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 204:
                    completion(nil, 204)
                case 300...500:
                    do {
                        self.category = try response.map(UserCategory?.self)
                        completion(self.category, nil)
                    } catch(let error) {
                        print(error.localizedDescription)
                        completion(nil, 500)
                    }
                default:
                    completion(nil, response.statusCode)
                }
                
            case.failure(let error):
                print(error.localizedDescription)
                completion(nil, 500)
            }
        }
    }
}
