//
//  SocialType.swift
//  WAL
//
//  Created by heerucan on 2022/12/15.
//

import Foundation

@frozen
enum SocialType: String {
    case KAKAO
    case APPLE
    
    var login: String {
        switch self {
        case .KAKAO:
            return "카카오 계정으로 로그인"
        case .APPLE:
            return "애플 계정으로 로그인"
        }
    }
}
