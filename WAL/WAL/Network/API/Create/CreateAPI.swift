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
        session: Session(interceptor: Interceptor()),
        plugins: [MoyaLoggerPlugin()]
    )

    private(set) var reserveResponse: GenericResponse<Reserve>?
    private(set) var reservedDateResponse: GenericArrayResponse<String>?
    
    func getReservedDate(completion: @escaping(([String]?, NetworkResult?) -> ())) {
        createProvider.request(.reservedDate) { result in
            switch result {
            case .success(let response):
                do {
                    self.reservedDateResponse = try response.map(GenericArrayResponse<String>?.self)
                    guard let response = self.reservedDateResponse, let data = response.data else {
                        completion(nil, .nullValue)
                        return
                    }
                    completion(data, nil)
                } catch(let error) {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil, .internalServerError)
            }
        }
    }
    
    func postReservation(reserve: Reserve, completion: @escaping((GenericResponse<Reserve>?, NetworkResult?) -> ())) {
        createProvider.request(.reserve(body: reserve)) { result in
            switch result {
            case .success(let response):
                do {
                    self.reserveResponse = try response.map(GenericResponse<Reserve>?.self)
                    guard let reserveData = self.reserveResponse else { return }
                    completion(reserveData, nil)
                } catch(let error) {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil, .internalServerError)
            }
        }
    }
}
