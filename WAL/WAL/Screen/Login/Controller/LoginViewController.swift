//
//  LoginViewController.swift
//  WAL
//
//  Created by heerucan on 2022/05/04.
//

import UIKit

import AuthenticationServices
import Gifu
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import Then
import WALKit

final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private let logoImageView = GIFImageView().then {
        $0.animate(withGIFNamed: "login500", loopCount: 5)
    }
    
    private let kakaoButton = WALAuthButton(type: .kakao).then {
        $0.addTarget(self, action: #selector(touchupKakaoButton), for: .touchUpInside)
        $0.alpha = 0
    }
    
    private let appleButton = WALAuthButton(type: .apple).then {
        $0.addTarget(self, action: #selector(touchupAppleButton), for: .touchUpInside)
        $0.alpha = 0
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupLayout()
        setLoginAnimation()
    }
    
    // MARK: - InitUI
    
    private func configUI() {
        view.backgroundColor = .orange100
        logoImageView.frame = view.bounds
    }
    
    private func setupLayout() {
        view.addSubviews([logoImageView, kakaoButton, appleButton])
        
        logoImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(250)
        }
        
        kakaoButton.snp.makeConstraints { make in
            make.bottom.equalTo(appleButton.snp.top).offset(-16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        appleButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(46)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - Custom Method
    
    private func setLoginAnimation() {
        UIView.animate(withDuration: 1, delay: 0.5) {
            self.logoImageView.transform = CGAffineTransform(translationX: 0, y: -80)
        }
        
        UIView.animate(withDuration: 1, delay: 0.5) {
            self.appleButton.alpha = 1
            self.kakaoButton.alpha = 1
        }
    }
    
    private func pushToHome() {
        // 어쨌든 이 경우에는 액세스 토큰이 없어서 로그인 단계를 거치는 것
        if UserDefaultsHelper.standard.complete == false {
            print("🛼 pushToHome() 로그인 후 온보딩을 완료하지 않아 온보딩뷰입니다.")
            let viewController = OnboardingViewController()
            transition(viewController, .presentFullNavigation)
        } else {
            // 로그인 -> 완료버튼을 눌러서 서버통신 성공인 경우에 -> 메인화면으로 이동
            print("🛼 pushToHome() 로그인 후 온보딩 완료 후 메인뷰입니다.")
            let viewController = MainViewController()
            transition(viewController, .presentFullNavigation)
        }
    }
    
    // MARK: - Checking Token
    
    private func setupFcmToken() -> String? {
        guard let fcmtoken = UserDefaultsHelper.standard.fcmtoken else { return nil }
        return fcmtoken["token"] as? String
    }
    
    // MARK: - @objc
    
    @objc func touchupKakaoButton() {
        if UserApi.isKakaoTalkLoginAvailable() {
            loginWithKakaoApp()
        } else {
            loginWithKakaoWeb()
        }
    }
    
    @objc func touchupAppleButton() {
        let authorizationProvider = ASAuthorizationAppleIDProvider()
        let request = authorizationProvider.createRequest()
        request.requestedScopes = [.email, .fullName]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

// MARK: - 카카오 로그인

extension LoginViewController {
    private func loginWithKakaoApp() {
        UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
            if let error = error {
                print(error)
            } else {
                UserApi.shared.me {(user, error) in
                    if let error = error {
                        print("----------- 카카오 로그인 앱 에러:", error)
                    } else {
                        guard let oauthToken = oauthToken else { return  }
                        AuthAPI.shared.postSocialLogin(
                            social: "kakao",
                            socialToken: oauthToken.accessToken,
                            fcmtoken: self.setupFcmToken()) { (kakaoData, err) in
                                guard let kakaoData = kakaoData,
                                      let accessData = kakaoData.data else { return }
                                UserDefaultsHelper.standard.accesstoken = accessData.accesstoken
                                UserDefaultsHelper.standard.refreshtoken = accessData.refreshtoken
                                UserDefaultsHelper.standard.socialtoken = oauthToken.accessToken
                                UserDefaultsHelper.standard.social = "kakao"
                                self.pushToHome()
                            }
                    }
                }
            }
        }
    }
    
    private func loginWithKakaoWeb() {
        UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
            if let error = error {
                print(error)
            } else {
                UserApi.shared.me { (user, error) in
                    if let error = error {
                        print("----------- 카카오 로그인 웹 에러 :", error)
                    } else {
                        guard let oauthToken = oauthToken else { return  }
                        AuthAPI.shared.postSocialLogin(
                            social: "kakao",
                            socialToken: oauthToken.accessToken,
                            fcmtoken: self.setupFcmToken()) { (kakaoData, err) in
                                guard let kakaoData = kakaoData,
                                      let accessData = kakaoData.data else { return }
                                if kakaoData.status == 401 {
                                    AuthAPI.shared.postReissue() { reissueData, err in
                                        if reissueData?.status == 401 {
                                            AuthAPI.shared.getLogout { (data, nil) in
                                                guard data != nil else { return }
                                            }
                                        }
                                        guard let reissueData = reissueData?.data else { return }
                                        UserDefaultsHelper.standard.accesstoken = reissueData.accesstoken
                                    }
                                } else {
                                    UserDefaultsHelper.standard.accesstoken = accessData.accesstoken
                                    UserDefaultsHelper.standard.refreshtoken = accessData.refreshtoken
                                    UserDefaultsHelper.standard.socialtoken = oauthToken.accessToken
                                    UserDefaultsHelper.standard.social = "kakao"
                                    self.pushToHome()
                                }
                            }
                    }
                }
            }
        }
    }
}

// MARK: - 애플 로그인

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        if let identityToken = appleIDCredential.identityToken {
            let tokenString = String(data: identityToken, encoding: .utf8)
            guard let tokenString = tokenString else { return }
            AuthAPI.shared.postSocialLogin(social: "apple", socialToken: tokenString, fcmtoken: setupFcmToken()) { (appleData, err) in
                guard let appleData = appleData,
                      let accessData = appleData.data else { return }
                UserDefaultsHelper.standard.accesstoken = accessData.accesstoken
                UserDefaultsHelper.standard.refreshtoken = accessData.refreshtoken
                UserDefaultsHelper.standard.socialtoken = tokenString
                UserDefaultsHelper.standard.social = "apple"
                self.pushToHome()
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("ERROR : 애플아이디", error.localizedDescription)
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
