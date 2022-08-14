//
//  Constant.swift
//  WAL
//
//  Created by heerucan on 2022/06/13.
//

import Foundation

struct Constant {
    private init() { }
    
    // MARK: - UserDefaults Key
    enum Key {
        static let accessToken = "accessToken"
        static let refreshToken = "refreshToken"
        static let socialToken = "socialToken"
        static let socialLogin = "socialLogin"
        static let nickname = "nickname"
    }
    
    // MARK: - URL
    enum URL {
        static let walURL = "https://receptive-humidity-bf2.notion.site/WAL-cde83326689247dfabaf712245f359fe"
        static let serviceURL = "https://receptive-humidity-bf2.notion.site/3f7f92f2f8f54b63907b84b7416eb8e8"
    }
    
    // MARK: - Placeholder
    enum Placeholder {
        static let warnText = "띄어쓰기 없이 한글, 영문, 숫자만 가능해요"
        static let resignText = "탈퇴 후 탈퇴 철회(탈퇴 취소)는 불가합니다. 탈퇴 후 회원정보 및 이용 기록은 모두 삭제되며, 다시 복구할 수 없습니다. 동일한 SNS 계정을 사용한 재가입은 탈퇴한 날짜 기준 24시간 이후에 가능합니다."
    }
}
