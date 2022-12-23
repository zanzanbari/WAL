//
//  SocialType.swift
//  WAL
//
//  Created by heerucan on 2022/12/15.
//

import Foundation

@frozen
enum SocialType: String {
    case kakao
    case apple
    
    var login: String {
        switch self {
        case .kakao:
            return "카카오 계정으로 로그인"
        case .apple:
            return "애플 계정으로 로그인"
        }
    }
}
