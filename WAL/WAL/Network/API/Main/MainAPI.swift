//
//  MainAPI.swift
//  WAL
//
//  Created by 소연 on 2022/07/01.
//

import Moya

final class MainAPI {
    static let shared: MainAPI = MainAPI()
    private init() { }
    private let mainProvider = MoyaProvider<MainService>(plugins: [MoyaLoggerPlugin()])

    private(set) var mainData: TodayWalList?
    private(set) var subtitle: MainSubtitle?
    
    /// 메인 - 오늘의 왈소리 조회
    func getMainData(completion: @escaping ((TodayWalList?, Int?) -> ())) {
        
        mainProvider.request(.todayWal) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                do {
                    self.mainData = try response.map(TodayWalList.self)
                    
                    // 200
                    if let _mainData = self.mainData {
                        completion(_mainData, response.statusCode)
                    } else {
                        completion(nil, response.statusCode)
                    }
                    
                } catch(let error) {
                    print(error.localizedDescription)
                    completion(nil, response.statusCode)
                }
                
            case .failure(let error):
                print("[오늘의 왈소리 조회] DEBUG: - \(error.localizedDescription)")
                completion(nil, error.response?.statusCode)
            }
        }
        
    }
    
    /// 메인 - 오늘의 왈소리 확인
    func updateMainData(id: Int, completion: @escaping ((Void, Int?) -> ())) {
        
        mainProvider.request(.openTodayWal(todayWalId: id)) { result in
            
            switch result {
            case .success(_):
                completion((), 200)
                
            case .failure(let error):
                print("[오늘의 왈소리 확인] DEBUG: - \(error.localizedDescription)")
                completion((), error.response?.statusCode)
            }
            
        }
        
    }
    
    /// 메인 - 서브타이틀 조회
    func getMainSubtitle(completion: @escaping ((MainSubtitle?, Int?) -> ())) {
        
        mainProvider.request(.subtitle) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                do {
                    self.subtitle = try response.map(MainSubtitle.self)
                    completion(self.subtitle, response.statusCode)
                } catch(let error) {
                    print(error.localizedDescription)
                    completion(nil, response.statusCode)
                }
                
            case .failure(let error):
                print("[서브 타이틀 조회] DEBUG: - \(error.localizedDescription)")
                completion(nil, error.response?.statusCode)
            }
        }
        
    }
}
