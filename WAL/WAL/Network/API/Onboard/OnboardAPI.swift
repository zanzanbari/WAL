//
//  OnboardAPI.swift
//  WAL
//
//  Created by heerucan on 2022/06/24.
//

import Foundation

import Moya

final class OnboardAPI {
    static let shared: OnboardAPI = OnboardAPI()
    private init() { }
    private let onboardProvider = MoyaProvider<OnboardService>(plugins: [MoyaLoggerPlugin()])

    private(set) var onboard: UserInfo?
    
    typealias completion = ((UserInfo?, Int?) -> ())
    
    // MARK: - POST 온보딩
    
    func postOnboard(nickname: String,
                     category: [String],
                     time: [String],
                     completion: @escaping completion) {
        
        let param = OnboardRequest.init(nickname: nickname, categoryTypes: category, timeTypes: time)
        
        onboardProvider.request(.onboard(param)) { result in
            switch result {
            case .success(let response):
                do {
                    self.onboard = try response.map(UserInfo?.self)
                    guard let onboard = self.onboard else { return }
                    completion(onboard, response.statusCode)
                    
                } catch(let error) {
                    print(error.localizedDescription)
                    completion(nil, response.statusCode)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil, error.response?.statusCode)
            }
        }
    }
}
