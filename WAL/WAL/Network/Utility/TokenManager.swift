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
        
    func refreshToken(_ statusCode: Int) {
        print(#function, statusCode)
        if statusCode == 401 {
            /// 리프레시 토큰 재발급
            AuthAPI.shared.postReissue() { data, error in
                print("🔶🔶🔶 AccessToken Expired: 토큰 재발급 >>> \n", data?.data as Any)

                /// 액세스 토큰 갈아끼우기
                guard let accessToken = data?.data else { return }
                UserDefaultsHelper.standard.accesstoken = accessToken.accesstoken

                /// 리프레시 토큰 만료 상태
                if data?.status == 401 {
                    print("🔶🔶🔶 RefreshToken Expired: 로그아웃 필요 >>> \n", data?.status as Any)

                    /// 로그아웃 서버통신
                    AuthAPI.shared.getLogout { data,_ in
                        guard let data = data else { return }
                        print("🔶🔶🔶 RefreshToken Expired: 로그아웃 서버통신 >>> \n", data)
                        self.pushToLoginView()
                    }
                }
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
