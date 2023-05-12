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
        session: Session(interceptor: Interceptor()),
        plugins: [MoyaLoggerPlugin()]
    )
    
    public private(set) var historyData: HistoryResponse?
    public private(set) var cancelHistoryData: GenericResponse<DeleteHistoryResponse>?
    public private(set) var deleteHistoryData: GenericResponse<DeleteHistoryResponse>?
    
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
    
    public func cancelHistoryData(postId: Int, completion: @escaping ((GenericResponse<DeleteHistoryResponse>?, Int?) -> ())) {
        historyProvider.request(.cancelReserve(postId: postId)) { result in
            switch result {
            case .success(let response):
                do {
                    self.cancelHistoryData = try response.map(GenericResponse<DeleteHistoryResponse>?.self)
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
    
    public func deleteHistoryData(postId: Int, completion: @escaping ((GenericResponse<DeleteHistoryResponse>?, Int?) -> ())) {
        historyProvider.request(.deleteReserve(postId: postId)) { result in
            switch result {
            case .success(let response):
                do {
                    self.deleteHistoryData = try response.map(GenericResponse<DeleteHistoryResponse>?.self)
                    guard let deleteHistoryData = self.deleteHistoryData else { return }
                    completion(deleteHistoryData, nil)
                    
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
