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
    
    public private(set) var mainData: GenericResponse<MainResponse>?
    
    public func getMainData(completion: @escaping ((GenericResponse<MainResponse>?, Int?) -> ())) {
        mainProvider.request(.main) { result in
            switch result {
            case .success(let response):
                do {
                    self.mainData = try response.map(GenericResponse<MainResponse>?.self)
                    guard let mainData = self.mainData else { return }
                    completion(mainData, nil)
                    
                } catch(let err) {
                    print(err.localizedDescription, 500)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil, 500)
            }
        }
    }
    
    public func updateMainData(item: Int, completion: @escaping ((GenericResponse<MainResponse>?, Int?) -> ())) {
        mainProvider.request(.mainItem(param: item)) { result in
            switch result {
            case .success(let response):
                do {
                    self.mainData = try response.map(GenericResponse<MainResponse>?.self)
                    guard let mainData = self.mainData else { return }
                    completion(mainData, nil)
                    
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
