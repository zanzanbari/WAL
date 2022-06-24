//
//  HistoryAPI.swift
//  WAL
//
//  Created by 소연 on 2022/06/24.
//

import Foundation

import Moya

final class HistoryAPI {
    static let shared: HistoryAPI = HistoryAPI()
    private let historyProvider = MoyaProvider<HistoryService>(plugins: [MoyaLoggerPlugin()])
    private init() { }
    
    public private(set) var historyData: GenericResponse<HistoryResponse>?
    
    public func getHealthMainData(completion: @escaping ((GenericResponse<HistoryResponse>?, Int?) -> ())) {
        historyProvider.request(.history) { result in
            switch result {
            case .success(let response):
                do {
                    self.historyData = try response.map(GenericResponse<HistoryResponse>?.self)
                    guard let historyData = self.historyData else { return }
                    completion(historyData, nil)
                    
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
