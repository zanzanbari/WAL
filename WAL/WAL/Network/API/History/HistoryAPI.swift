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
    private init() { }
    private let historyProvider = MoyaProvider<HistoryService>(
//        session: Session(interceptor: Interceptor()),
        plugins: [MoyaLoggerPlugin()]
    )
    
    public private(set) var historyData: HistoryResponse?
    public private(set) var cancelHistoryData: DefaultResponse?
    public private(set) var deleteHistoryData: DefaultResponse?
    
   func getHistoryData(completion: @escaping ((HistoryResponse?, Int?) -> ())) {
        historyProvider.request(.history) { [weak self] result in
            guard let _self = self else { return }
            
            switch result {
            case .success(let response):
                do {
                    _self.historyData = try response.map(HistoryResponse?.self)
                    guard let historyData = _self.historyData else { return }
                    completion(historyData, response.statusCode)
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
    
    func cancelHistoryData(reservationId: Int, completion: @escaping ((Void, Int?) -> ())) {
        historyProvider.request(.cancelReserve(reservationId: reservationId)) { [weak self] result in
            guard let _self = self else { return }
            
            switch result {
            case .success(let response):
                completion((), response.statusCode)
            case .failure(let error):
                print(error.localizedDescription)
                completion((), error.response?.statusCode)
            }
        }
    }
    
    func deleteHistoryData(reservationId: Int, completion: @escaping ((Void, Int?) -> ())) {
        historyProvider.request(.deleteReserve(reservationId: reservationId)) { [weak self] result in
            guard let _self = self else { return }
            
            switch result {
            case .success(let response):
                completion((), response.statusCode)
            case .failure(let error):
                print(error.localizedDescription)
                completion((), error.response?.statusCode)
            }
        }
    }
}
