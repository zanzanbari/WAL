//
//  CreateAPI.swift
//  WAL
//
//  Created by 배은서 on 2022/07/14.
//

import Foundation

import Moya

final class CreateAPI {
    static let shared: CreateAPI = CreateAPI()
    private init() {}
    private let createProvider = MoyaProvider<CreateService>(plugins: [MoyaLoggerPlugin()])
    
    private(set) var reserveResponse: DefaultResponse?
    private(set) var reservedDateResponse: ReservedDateResponse?
    
    func getReservedDate(completion: @escaping(([String]?, Int?) -> ())) {
        createProvider.request(.reservedDate) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                do {
                    self.reservedDateResponse = try response.map(ReservedDateResponse.self)
                    
                    guard let reservedDateResponse = self.reservedDateResponse,
                          let reservedDates = reservedDateResponse.reserveDates else {
                        completion(nil, nil)
                        return
                    }
                    
                    completion(reservedDates, nil)
                } catch(let error) {
                    print(error.localizedDescription)
                    completion(nil, response.statusCode)
                }
            case .failure(let error):
                print("[예약 날짜 조회] DEBUG: - \(error.localizedDescription)")
                completion(nil, error.response?.statusCode)
            }
        }
    }
    
    func postReservation(reserve: Reserve, completion: @escaping((Void, Int?) -> ())) {
        createProvider.request(.reserve(body: reserve)) { [self] result in
            switch result {
            case .success(let response):
                if self.reserveResponse?.statusCase == nil {
                    completion((), response.statusCode)
                }
            case .failure(let error):
                print("[예약 POST] DEBUG: - \(error.localizedDescription)")
                completion((), error.response?.statusCode)
            }
        }
    }
}
