//
//  TokenManager.swift
//  WAL
//
//  Created by heerucan on 2022/12/13.
//

import Foundation

import Moya

final class TokenManager {
    private init() { }
    
    static let shared = TokenManager()
        
    func refreshTokenAPI(_ statusCode: Int) {
        print(#function)
        AuthAPI.shared.postReissue { [weak self] tokenData, status in
            guard let self = self else { return }
            /// 성공적으로 액세스 토큰이 갱신됐다면,
            if let tokenData = tokenData?.data {
                print("♻️ 1-2. 성공적으로 액세스 토큰이 갱신되었구요, 일단 로그아웃을 시켜볼게요!")
                print("♻️ 1-2-1. 갱신된 액세스 토큰이구요 ->> ", tokenData.accesstoken)
                print("♻️ 1-2-2. 리프레시 토큰이구요 ->> ", tokenData.refreshtoken)

                UserDefaultsHelper.standard.accesstoken = tokenData.accesstoken
                UserDefaultsHelper.standard.refreshtoken = tokenData.refreshtoken
                print("♻️ 1-3-1. 액세스토큰 새롭게 저장 - ", UserDefaultsHelper.standard.accesstoken as Any)
                print("♻️ 1-3-2. 리프레시토큰도 새롭게 저장 - ", UserDefaultsHelper.standard.refreshtoken as Any)
            }

            /// 401이 뜨면 리프레시 토큰도 만료
            /// 로그아웃 서버통신 + 액세스 토큰 삭제
            if let statusCode = tokenData?.status, statusCode == 401 {
                print("♻️ 2-1. 리프레시 토큰 만료! -> 로그아웃")
                self.pushToLoginView()
            }
        }
    }
    
    func pushToLoginView() {
        print(#function, "로그인뷰로 이동")
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        let viewController = LoginViewController()
        sceneDelegate?.window?.rootViewController = viewController
        sceneDelegate?.window?.makeKeyAndVisible()
        UserDefaultsHelper.standard.removeAccessToken()
    }
}
