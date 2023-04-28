//
//  MainResponse.swift
//  WAL
//
//  Created by 소연 on 2022/07/01.
//

import UIKit

/// 오늘의 왈소리 목록 (메인화면 진입 시 Response)
struct TodayWalList: BaseResponse, Codable {
    
    var statusCode: Int?
    var message: String?
    
    let todayWalInfo: [TodayWal]?
    
    var statusCase: NetworkResult? {
        return NetworkResult(rawValue: statusCode ?? -999)
    }
    
    enum CodingKeys: String, CodingKey {
        case statusCode
        case message
        case todayWalInfo
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.statusCode = try container.decodeIfPresent(Int.self, forKey: .statusCode) ?? 0
        self.message = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
        self.todayWalInfo = try container.decodeIfPresent([TodayWal].self, forKey: .todayWalInfo) ?? []
    }
    
}

/// 왈소리 1개의 데이터
struct TodayWal: Codable {
    let todayWalId: Int?
    let timeType: String?
    let categoryType: String?
    let message: String?
    let showStatus: String?
    let openStatus: String?
    
    func getShowStatus() -> Bool {
        return TodayWalShowStatus(rawValue: showStatus ?? "")?.status ?? false
    }
    
    func getOpenStatus() -> Bool {
        return TodayWalOpenStatus(rawValue: openStatus ?? "")?.status ?? false
    }
    
    func getCategoryType() -> WalCategoryType {
        return WalCategoryType(rawValue: categoryType ?? "") ?? .none
    }
    
    func getTimeType() -> AlarmTimeType {
        return AlarmTimeType(rawValue: timeType ?? "") ?? .none
    }
}

/// 왈소리 조회 상태 (사용자가 보았는지)
enum TodayWalShowStatus: String {
    case open     = "OPEN"
    case closed   = "CLOSED"
    
    var status: Bool {
        switch self {
        case .open:      return true
        case .closed:    return false
        }
    }
}

/// 왈소리 조회 가능 상태 (사용자가 볼 수 있는지)
enum TodayWalOpenStatus: String {
    case able     = "ABLE"
    case disable  = "UNABLE"
    
    var status: Bool {
        switch self {
        case .able:      return true
        case .disable:   return false
        }
    }
}



