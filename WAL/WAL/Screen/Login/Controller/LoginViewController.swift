//
//  LoginViewController.swift
//  WAL
//
//  Created by heerucan on 2022/05/04.
//

import UIKit

import AuthenticationServices
import Lottie
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import Then
import WALKit

final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private var accessToken: String = ""
    private var socialLogin: String = ""
    private var socialToken: String = ""
    private var refreshToken: String = ""
    
    private let logoImageView = AnimationView().then {
        $0.animation = Animation.named("login")
        $0.contentMode = .scaleAspectFit
        $0.loopMode = .repeat(5)
        $0.play()
    }
    
    private let kakaoButton = WALAuthButton(type: .kakao).then {
        $0.addTarget(self, action: #selector(touchupKakaoButton), for: .touchUpInside)
    }
    
    private let appleButton = WALAuthButton(type: .apple).then {
        $0.addTarget(self, action: #selector(touchupAppleButton), for: .touchUpInside)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupLayout()
        checkToken()
    }
    
    // MARK: - InitUI
    
    private func configUI() {
        view.backgroundColor = .orange100
        logoImageView.frame = view.bounds
    }
    
    private func setupLayout() {
        view.addSubviews([logoImageView, kakaoButton, appleButton])
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(150)
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(250)
        }
        
        kakaoButton.snp.makeConstraints { make in
            make.bottom.equalTo(appleButton.snp.top).offset(-16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        appleButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(80)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - Custom Method
    
    private func setUserDefaults(_ type: String,
                                 _ accessToken: String,
                                 _ refreshToken: String,
                                 _ socialToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.socialToken = socialToken
        socialLogin = type
        UserDefaults.standard.set(accessToken, forKey: Constant.Key.accessToken)
        UserDefaults.standard.set(socialToken, forKey: Constant.Key.socialToken)
        UserDefaults.standard.set(type, forKey: Constant.Key.socialLogin)
        UserDefaults.standard.set(refreshToken, forKey: Constant.Key.refreshToken)
    }
    
    private func pushToHome() {
        let viewController = UINavigationController(rootViewController: OnboardingViewController())
        viewController.navigationBar.isHidden = true
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
    
    private func checkToken() {
        // MARK: - 토큰 존재 여부 확인하기
        if (AuthApi.hasToken()) {
            UserApi.shared.accessTokenInfo { (accessTokenInfo, error) in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() {
                        //로그인 필요
                    } else { }
                } else {
                    //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                }
            }
        } else { }
        
        // MARK: - 토큰 정보 보기
        UserApi.shared.accessTokenInfo {(accessTokenInfo, error) in
            if let error = error { print(error) } else {
                _ = accessTokenInfo
            }
        }
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
            self.accessToken = oauthToken!.accessToken
            if let error = error { print(error)
            } else {
                UserApi.shared.me {(user, error) in
                    if let error = error {
                        print("----------- 카카오 로그인 앱 에러:", error)
                    } else {
                        guard let oauthToken = oauthToken else { return  }
                        AuthAPI.shared.postSocialLogin(
                            social: "kakao",
                            socialToken: oauthToken.accessToken,
                            fcmToken: nil) { (kakaoData, err) in
                                guard let kakaoData = kakaoData,
                                      let accessData = kakaoData.data else { return }
                                self.setUserDefaults("kakao",
                                                     accessData.accesstoken,
                                                     accessData.refreshtoken,
                                                     oauthToken.accessToken)
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
                self.accessToken = oauthToken!.accessToken
                UserApi.shared.me {(user, error) in
                    if let error = error {
                        print("----------- 카카오 로그인 웹 에러 :", error)
                    } else {
                        guard let oauthToken = oauthToken else { return  }
                        AuthAPI.shared.postSocialLogin(
                            social: "kakao",
                            socialToken: oauthToken.accessToken,
                            fcmToken: nil) { (kakaoData, err) in
                                guard let kakaoData = kakaoData,
                                      let accessData = kakaoData.data else { return }
                                if kakaoData.status == 401 {
                                    AuthAPI.shared.postReissue() { reissueData, err in
                                        
                                        // MARK: - TODO 리프레시토큰도 만료 -> 로그아웃
                                        if reissueData?.status == 401 {
                                            AuthAPI.shared.getLogout { (data, nil) in
                                                guard data != nil else { return }
                                                
                                            }
                                        }
                                        guard let reissueData = reissueData?.data else { return }
                                        self.accessToken = reissueData.accesstoken
                                        UserDefaults.standard.set(self.accessToken, forKey: Constant.Key.accessToken)
                                    }
                                } else {
                                    self.setUserDefaults("kakao",
                                                         accessData.accesstoken,
                                                         accessData.refreshtoken,
                                                         oauthToken.accessToken)
                                }
                                self.pushToHome()
                            }
                    }
                }
            }
        }
    }
}

// MARK: - 애플 로그인 ASAuthorizationControllerDelegate

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        if let identityToken = appleIDCredential.identityToken {
            let tokenString = String(data: identityToken, encoding: .utf8)
            guard let tokenString = tokenString else { return }
            var email = appleIDCredential.email ?? ""
            
            AuthAPI.shared.postSocialLogin(social: "apple",
                                           socialToken: tokenString,
                                           fcmToken: nil) { (appleData, err) in
                guard let appleData = appleData,
                        let accessData = appleData.data else { return }
                self.setUserDefaults("apple",
                                     accessData.accesstoken,
                                     accessData.refreshtoken,
                                     tokenString)
                self.pushToHome()
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("ERROR : 애플아이디", error.localizedDescription)
    }
}

// MARK: - 애플 로그인 ASAuthorizationControllerPresentationContextProviding

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
