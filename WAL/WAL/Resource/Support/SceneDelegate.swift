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
        print("SceneDelegate", nickname, accesstoken)
        
        if nickname != "" && accesstoken != "" {
            // 닉네임O, 액세스토큰O -> 자동로그인 -> 메인
            print("- 자동로그인 후 온보딩 완료해서 메인뷰.")
            window?.rootViewController = UINavigationController(rootViewController: MainViewController(viewModel: .init()))
        } else if nickname == "" && accesstoken != "" {
            // 닉네임X, 액세스토큰O -> 온보딩
            print("- 자동로그인 후 온보딩을 완료하지 않아서 온보딩뷰.")
            window?.rootViewController = UINavigationController(rootViewController: OnboardingViewController())
        } else if nickname == "" && accesstoken == "" {
            // 닉네임X, 액세스토큰X -> 로그인
            print("- 가입이 완료되지 않아 로그인뷰.")
            window?.rootViewController = LoginViewController(viewModel: LoginViewModel())
        } else if nickname != "" && accesstoken == "" {
            // 닉네임O, 액세스토큰X -> 로그인
            window?.rootViewController = LoginViewController(viewModel: LoginViewModel())
        }
        
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) { }
    
    func sceneDidBecomeActive(_ scene: UIScene) { }
    
    func sceneWillResignActive(_ scene: UIScene) { }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        NotificationCenter.default.post(name: NSNotification.Name.enterMain, object: nil)
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) { }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
}
