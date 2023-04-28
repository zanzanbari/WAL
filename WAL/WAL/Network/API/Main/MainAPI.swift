//
//  MainAPI.swift
//  WAL
//
//  Created by 소연 on 2022/07/01.
//

import Moya

final class MainAPI {
    static let shared: MainAPI = MainAPI()
    private let mainProvider = MoyaProvider<MainService>(plugins: [MoyaLoggerPlugin()])
    private init() { }
    
    private(set) var mainData: TodayWalList?
    
    private var refreshValue = 0
    
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
                        completion(_mainData, nil)
                    } else {
                        
                        // 300 ~ 500
                        if let _statusCase = self.mainData?.statusCase {
                            switch _statusCase {
                            case .unAuthorized:
                                self.refreshValue += 1
                                print("이것입니다 ===>>>", self.refreshValue)
                                TokenManager.shared.refreshTokenAPI(401)
                                self.getMainData(completion: completion)
                            default:
                                return
                            }
                            
                            completion(nil, self.mainData?.statusCode)
                        }
                        
                    }
                    
                } catch(let err) {
                    print(err.localizedDescription, 500)
                    completion(nil, 500)
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil, 500)
            }
        }
        
    }
    
    /// 메인 - 오늘의 왈소리 확인
    func updateMainData(id: Int, completion: @escaping ((Void, Int?) -> ())) {
        
        mainProvider.request(.openTodayWal(todayWalId: id)) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                do {
                    
                    // 300 ~ 500
                    if let _statusCase = self.mainData?.statusCase {
                        switch _statusCase {
                        case .unAuthorized:
                            self.refreshValue += 1
                            print("이것입니다 ===>>>", self.refreshValue)
                            TokenManager.shared.refreshTokenAPI(401)
                            self.updateMainData(id: id, completion: completion)
                        default:
                            return
                        }
                    }
                    
                    completion((), nil)
                    
                    
                } catch(let err) {
                    print(err.localizedDescription, 500)
                    completion((), 500)
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion((), 500)
            }
        }
        
    }
    
}
