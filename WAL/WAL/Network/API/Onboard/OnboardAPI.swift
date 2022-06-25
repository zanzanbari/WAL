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
    private let onboardProvider = MoyaProvider<OnboardService>(plugins: [MoyaLoggerPlugin()])
    private init() { }
    
    public private(set) var onboardData: GenericResponse<Onboard>?
    
    // MARK: - POST 온보딩
    
    public func postOnboardSetting(nickname: String, dtype: Dtype, time: AlarmTime,
                                completion: @escaping ((GenericResponse<Onboard>?, Int?) -> ())) {
        
        let param = OnboardRequest.init(nickname, dtype, time)
        
        onboardProvider.request(.setInfo(param: param)) { result in
            switch result {
            case .success(let response):
                do {
                    self.onboardData = try response.map(GenericResponse<Onboard>?.self)
                    guard let onboardData = self.onboardData else { return }
                    completion(onboardData, nil)
                    
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
