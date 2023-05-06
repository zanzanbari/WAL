//
//  SettingAPI.swift
//  WAL
//
//  Created by heerucan on 2022/08/13.
//

import Foundation

import Moya

final class SettingAPI {
    private init() { }
    static let shared = SettingAPI()
    private let settingProvider = MoyaProvider<SettingService>(plugins: [MoyaLoggerPlugin()])
    
    typealias completion = (UserInfo?, Int?) -> ()
    typealias alarmCompletion = (UserAlarm?, Int?) -> ()
    typealias categoryCompletion = (UserCategory?, Int?) -> ()
    
    private(set) var userInfo: UserInfo?
    private(set) var alarm: UserAlarm?
    private(set) var category: UserCategory?
    
    // MARK: - GET 유저 닉네임 조회하기
    
    func getUserInfo(completion: @escaping completion) {
        settingProvider.request(.checkNickname) { result in
            switch result {
            case .success(let response):
                do {
                    self.userInfo = try response.map(UserInfo?.self)
                    guard let userInfo = self.userInfo else { return }
                    completion(userInfo, nil)
                    
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
        settingProvider.request(.editNickname(nickname: Onboard(nickname: nickname))) { result in
            switch result {
            case .success(let response):
                do {
                    self.userInfo = try response.map(UserInfo?.self)
                    guard let userInfo = self.userInfo else { return }
                    completion(userInfo, nil)
                    
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
    
    func getUserAlarm(alarmCompletion: @escaping alarmCompletion) {
        settingProvider.request(.checkAlarm) { result in
            switch result {
            case .success(let response):
                do {
                    self.alarm = try response.map(UserAlarm?.self)
                    guard let alarm = self.alarm else { return }
                    alarmCompletion(alarm, nil)
                    
                } catch(let error) {
                    print(error.localizedDescription)
                }
                
            case.failure(let error):
                print(error.localizedDescription)
                alarmCompletion(nil, 500)
            }
        }
    }
    
    
    // MARK: - POST 알림 시간 수정하기
    
    func postUserAlarm(data: [AlarmTime], alarmCompletion: @escaping alarmCompletion) {
        let param = UserAlarmRequest(data: data)
        settingProvider.request(.editAlarm(alarm: param)) { result in
            switch result {
            case .success(let response):
                do {
                    self.alarm = try response.map(UserAlarm?.self)
                    guard let alarm = self.alarm else { return }
                    alarmCompletion(alarm, nil)
                    
                } catch(let error) {
                    print(error.localizedDescription)
                }
                
            case.failure(let error):
                print(error.localizedDescription)
                alarmCompletion(nil, 500)
            }
        }
    }
    
    // MARK: - GET 카테고리 조회하기
    
    func getUserCategory(categoryCompletion: @escaping categoryCompletion) {
        settingProvider.request(.checkCategory) { result in
            switch result {
            case .success(let response):
                do {
                    self.category = try response.map(UserCategory?.self)
                    guard let category = self.category else { return }
                    categoryCompletion(category, nil)
                    
                } catch(let error) {
                    print(error.localizedDescription)
                }
                
            case.failure(let error):
                print(error.localizedDescription)
                categoryCompletion(nil, 500)
            }
        }
    }
    
    // MARK: - POST 카테고리 수정하기
    func postUserCategory(data: [CategoryType], categoryCompletion: @escaping categoryCompletion) {
        let param = UserCategoryRequest(data: data)
        settingProvider.request(.editCategory(category: param)) { result in
            switch result {
            case .success(let response):
                do {
                    self.category = try response.map(UserCategory?.self)
                    guard let category = self.category else { return }
                    categoryCompletion(category, nil)
                    
                } catch(let error) {
                    print(error.localizedDescription)
                }
                
            case.failure(let error):
                print(error.localizedDescription)
                categoryCompletion(nil, 500)
            }
        }
    }
}
