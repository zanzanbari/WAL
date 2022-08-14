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
    typealias timeCompletion = (UserTime?, Int?) -> ()
    typealias categoryCompletion = (UserCategory?, Int?) -> ()
    
    public private(set) var userInfoData: UserInfo?
    public private(set) var userTimeData: UserTime?
    public private(set) var userCategoryData: UserCategory?
    
    // MARK: - GET 유저 닉네임 조회하기
    
    public func getUserInfo(completion: @escaping completion) {
        settingProvider.request(.checkUserInfo) { result in
            switch result {
            case .success(let response):
                do {
                    self.userInfoData = try response.map(UserInfo?.self)
                    guard let userInfoData = self.userInfoData else {
                        return
                    }
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
    
    public func postUserInfo(nickname: String, completion: @escaping completion) {
        settingProvider.request(.editUserInfo(nickname: Onboard(nickname: nickname))) { result in
            switch result {
            case .success(let response):
                do {
                    self.userInfoData = try response.map(UserInfo?.self)
                    guard let userInfoData = self.userInfoData else {
                        return
                    }
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
    
    public func getUserTime(timeCompletion: @escaping timeCompletion) {
        settingProvider.request(.checkTime) { result in
            switch result {
            case .success(let response):
                do {
                    self.userTimeData = try response.map(UserTime?.self)
                    guard let userTimeData = self.userTimeData else {
                        return
                    }
                    timeCompletion(userTimeData, nil)
                    
                } catch(let error) {
                    print(error.localizedDescription)
                }
                
            case.failure(let error):
                print(error.localizedDescription)
                timeCompletion(nil, 500)
            }
        }
    }
    
    
    // MARK: - POST 알림 시간 수정하기
    
    public func postUserTime(data: [AlarmTime], timeCompletion: @escaping timeCompletion) {
        
        let param = UserTimeRequest(data: data)
        
        settingProvider.request(.editTime(time: param)) { result in
            switch result {
            case .success(let response):
                do {
                    self.userTimeData = try response.map(UserTime?.self)
                    guard let userTimeData = self.userTimeData else {
                        return
                    }
                    timeCompletion(userTimeData, nil)
                    
                } catch(let error) {
                    print(error.localizedDescription)
                }
                
            case.failure(let error):
                print(error.localizedDescription)
                timeCompletion(nil, 500)
            }
        }
    }
    
    // MARK: - GET 카테고리 조회하기
    
    public func getUserCategory(categoryCompletion: @escaping categoryCompletion) {
        settingProvider.request(.checkCategory) { result in
            switch result {
            case .success(let response):
                do {
                    self.userCategoryData = try response.map(UserCategory?.self)
                    guard let userCategoryData = self.userCategoryData else {
                        return
                    }
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
    // dtype에 변경 전과 후 카테고리 선택 Bool 타입을 다 넣어서 보내줘야 한다.
    public func postUserCategory(dtype: [CategoryType], categoryCompletion: @escaping categoryCompletion) {
        
        let param = UserCategoryRequest(data: dtype)
        
        settingProvider.request(.editCategory(param: param)) { result in
            switch result {
            case .success(let response):
                do {
                    self.userCategoryData = try response.map(UserCategory?.self)
                    guard let userCategoryData = self.userCategoryData else {
                        return
                    }
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
