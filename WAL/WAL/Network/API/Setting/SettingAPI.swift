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
    
    private(set) var userInfoData: UserInfo?
    private(set) var userAlarmData: UserAlarm?
    private(set) var userCategoryData: UserCategory?
    
    // MARK: - GET 유저 닉네임 조회하기
    
    func getUserInfo(completion: @escaping completion) {
        settingProvider.request(.checkUserInfo) { result in
            switch result {
            case .success(let response):
                do {
                    self.userInfoData = try response.map(UserInfo?.self)
                    guard let userInfoData = self.userInfoData else { return }
                    completion(userInfoData, nil)
                    
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
        settingProvider.request(.editUserInfo(nickname: Onboard(nickname: nickname))) { result in
            switch result {
            case .success(let response):
                do {
                    self.userInfoData = try response.map(UserInfo?.self)
                    guard let userInfoData = self.userInfoData else { return }
                    completion(userInfoData, nil)
                    
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
                    self.userAlarmData = try response.map(UserAlarm?.self)
                    guard let userTimeData = self.userAlarmData else { return }
                    alarmCompletion(userTimeData, nil)
                    
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
                    self.userAlarmData = try response.map(UserAlarm?.self)
                    guard let userTimeData = self.userAlarmData else { return }
                    alarmCompletion(userTimeData, nil)
                    
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
                    self.userCategoryData = try response.map(UserCategory?.self)
                    guard let userCategoryData = self.userCategoryData else { return }
                    categoryCompletion(userCategoryData, nil)
                    
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
                    self.userCategoryData = try response.map(UserCategory?.self)
                    guard let userCategoryData = self.userCategoryData else { return }
                    categoryCompletion(userCategoryData, nil)
                    
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
