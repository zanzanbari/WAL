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
    
    public func getHistoryData(completion: @escaping ((HistoryResponse?, Int?) -> ())) {
        historyProvider.request(.history) { result in
            switch result {
            case .success(let response):
                do {
                    self.historyData = try response.map(HistoryResponse?.self)
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
    
    public func cancelHistoryData(reservationId: Int, completion: @escaping ((DefaultResponse?, Int?) -> ())) {
        historyProvider.request(.cancelReserve(reservationId: reservationId)) { result in
            switch result {
            case .success(let response):
                print("✅")
                do {
                    self.cancelHistoryData = try response.map(DefaultResponse?.self)
                    guard let cancelHistoryData = self.cancelHistoryData else { return }
                    completion(cancelHistoryData, nil)
                    
                } catch(let err) {
                    print(err.localizedDescription, 500)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil, 500)
            }
        }
    }
    
    public func deleteHistoryData(reservationId: Int, completion: @escaping ((DefaultResponse?, Int?) -> ())) {
        historyProvider.request(.deleteReserve(reservationId: reservationId)) { result in
            switch result {
            case .success(let response):
                print("✅")
                do {
                    self.deleteHistoryData = try response.map(DefaultResponse?.self)
                    guard let deleteHistoryData = self.deleteHistoryData else { return }
                    completion(deleteHistoryData, nil)
                } catch(let err) {
                    print(err.localizedDescription)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil, 500)
            }
        }
    }
}
