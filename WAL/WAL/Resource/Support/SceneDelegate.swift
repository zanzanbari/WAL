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
        
        // 액세스토큰 X -> 로그인 화면을 띄워줄 경우
        guard let accesstoken = UserDefaultsHelper.standard.accesstoken else { return }
        print("🛼", UserDefaultsHelper.standard.complete, accesstoken)
        if accesstoken == "" {
            print("🛼 scene() 로그인이 완료되지 않아 로그인뷰입니다.")
            window?.rootViewController = LoginViewController()
        } else {
            // 액세스토큰 O -> 자동로그인 -> 근데 아직 온보딩화면을 완료X
            if UserDefaultsHelper.standard.complete == false {
                print("🛼 scene() 자동로그인 후 온보딩을 완료하지 않아서 온보딩뷰입니다.")
                window?.rootViewController = UINavigationController(rootViewController: OnboardingViewController())
                window?.makeKeyAndVisible()
            } else {
                // 액세스토큰 O -> 자동로그인 -> 완료버튼을 눌러서 서버통신 성공인 경우에 -> 메인화면으로 이동
                print("🛼 scene() 자동로그인 후 온보딩 완료해서 메인뷰입니다.")
                window?.rootViewController = UINavigationController(rootViewController: MainViewController())
                window?.makeKeyAndVisible()
            }
        }
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        NotificationCenter.default.post(name: NSNotification.Name.enterMain, object: nil)
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
}
