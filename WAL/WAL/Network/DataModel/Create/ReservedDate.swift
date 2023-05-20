//
//  ReservedDate.swift
//  WAL
//
//  Created by 배은서 on 2023/05/09.
//

import Foundation

struct ReservedDateResponse: BaseResponse, Codable {
    var reserveDates: [String]?
    var statusCode: Int?
    var message: String?
}
