//
//  SceneDelegate.swift
//  WAL
//
//  Created by Thisisme Hi on 2022/04/01.
//

import UIKit

import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        guard let nickname = UserDefaultsHelper.standard.nickname else { return }
        guard let accesstoken = UserDefaultsHelper.standard.accesstoken else { return }
        
        if nickname != Constant.Login.nickname && accesstoken != "" { ///닉네임O, 액세스토큰O -> 자동로그인 -> 메인
            window?.rootViewController = UINavigationController(rootViewController: MainViewController())
        } else if nickname == Constant.Login.nickname && accesstoken != "" { ///닉네임X, 액세스토큰O -> 온보딩
            window?.rootViewController = UINavigationController(rootViewController: OnboardingViewController())
        } else { /// 로그인
            window?.rootViewController = LoginViewController(viewModel: LoginViewModel())
        }
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) { }
    
    func sceneDidBecomeActive(_ scene: UIScene) { }
    
    func sceneWillResignActive(_ scene: UIScene) { }
    
    func sceneWillEnterForeground(_ scene: UIScene) { }
    
    func sceneDidEnterBackground(_ scene: UIScene) { }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
}
