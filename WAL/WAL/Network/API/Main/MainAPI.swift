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
    private let mainProvider = MoyaProvider<MainService>(
//        session: Session(interceptor: Interceptor()),
        plugins: [MoyaLoggerPlugin()]
    )

    private(set) var mainData: TodayWalList?
    private(set) var subtitle: MainSubtitle?
    
    /// 메인 - 오늘의 왈소리 조회
    func getMainData(completion: @escaping ((TodayWalList?, Int?) -> ())) {
        
        mainProvider.request(.todayWal) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                do {
                    self.mainData = try response.map(TodayWalList.self)
                    
                    // 200
                    if let _mainData = self.mainData {
                        completion(_mainData, 200)
                    } else {
                        completion(nil, response.statusCode)
                    }
                    
                } catch(let err) {
                    print(err.localizedDescription)
                    completion(nil, response.statusCode)
                }
                
            case .failure(let err):
                print("[오늘의 왈소리 조회] DEBUG: - \(err.localizedDescription)")
                completion(nil, err.response?.statusCode)
            }
        }
        
    }
    
    /// 메인 - 오늘의 왈소리 확인
    func updateMainData(id: Int, completion: @escaping ((Void, Int?) -> ())) {
        
        mainProvider.request(.openTodayWal(todayWalId: id)) { [weak self] result in
            
            switch result {
            case .success(_):
                completion((), 200)
                
            case .failure(let err):
                print("[오늘의 왈소리 확인] DEBUG: - \(err.localizedDescription)")
                completion((), err.response?.statusCode)
            }
            
        }
        
    }
    
    /// 메인 - 서브타이틀 조회
    func getMainSubtitle(completion: @escaping ((MainSubtitle?, Int?) -> ())) {
        
        mainProvider.request(.subtitle) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                do {
                    self.subtitle = try response.map(MainSubtitle.self)
                    completion(self.subtitle, 200)
                } catch(let err) {
                    print(err.localizedDescription)
                    completion(nil, response.statusCode)
                }
                
            case .failure(let err):
                print("[서브 타이틀 조회] DEBUG: - \(err.localizedDescription)")
                completion(nil, err.response?.statusCode)
            }
        }
        
    }
}
