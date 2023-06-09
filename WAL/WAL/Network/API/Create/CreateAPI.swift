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
    
    private let createProvider = MoyaProvider<CreateService>(
//        session: Session(interceptor: Interceptor()),
        plugins: [MoyaLoggerPlugin()]
    )
    
    private(set) var reserveResponse: DefaultResponse?
    private(set) var reservedDateResponse: ReservedDateResponse?
    
    func getReservedDate(completion: @escaping(([String]?, NetworkResult?) -> ())) {
        createProvider.request(.reservedDate) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                do {
                    self.reservedDateResponse = try response.map(ReservedDateResponse.self)
                    
                    guard let reservedDateResponse = self.reservedDateResponse, let reservedDates = reservedDateResponse.reserveDates else {
                        completion(nil, .nullValue)
                        return
                    }
                    completion(reservedDates, nil)
                } catch(let error) {
                    print(error.localizedDescription)
                    completion(nil, .internalServerError)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil, .internalServerError)
            }
        }
    }
    
    func postReservation(reserve: Reserve, completion: @escaping((Void, NetworkResult?) -> ())) {
        createProvider.request(.reserve(body: reserve)) { [self] result in
            switch result {
            case .success(_):
                do {
                    if self.reserveResponse?.statusCase == nil {
                        completion((), .created)
                    }
                } catch(let error) {
                    print(error.localizedDescription)
                    completion((), reserveResponse?.statusCase)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion((), .internalServerError)
            }
        }
    }
}
