//
//  LoginViewController.swift
//  WAL
//
//  Created by heerucan on 2022/05/04.
//

import UIKit

import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import Then
import WALKit

final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private let logoImageView = UIImageView().then {
        $0.backgroundColor = .gray500
    }
    
    private let logoLabel = UILabel().then {
        $0.text = "잔잔한 인생에 한줄기 소리, 왈"
        $0.font = WALFont.body3.font
        $0.textColor = .black100
        $0.textAlignment = .center
    }
    
    private let kakaoButton = WALAuthButton().then {
        $0.authType = .kakao
        $0.addTarget(self, action: #selector(touchupKakaoButton), for: .touchUpInside)
    }
    
    private let appleButton = WALAuthButton().then {
        $0.authType = .apple
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
        view.backgroundColor = .white
    }
    
    private func setupLayout() {
        view.addSubviews([logoImageView, logoLabel,
                          kakaoButton, appleButton])
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(207)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(138)
        }
        
        logoLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(29)
            make.centerX.equalToSuperview()
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
    
    private func pushToHome() {
        let onboardingViewController = OnboardingViewController()
        present(onboardingViewController, animated: true, completion: nil)
    }
    
    private func checkToken() {
        // MARK: - 토큰 존재 여부 확인하기
        
        if (AuthApi.hasToken()) {
            UserApi.shared.accessTokenInfo { (accessTokenInfo, error) in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() {
                        //로그인 필요
                    }
                    else {
                        //기타 에러
                    }
                }
                else {
                    //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                }
            }
        }
        else {
            //로그인 필요
        }
        
        // MARK: - 토큰 정보 보기
        
        UserApi.shared.accessTokenInfo {(accessTokenInfo, error) in
            if let error = error { print(error) } else {
                print("------------액세스 토큰 : accessTokenInfo() success.")
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
            if let error = error { print(error)
            } else {
                UserApi.shared.me {(user, error) in
                    if let error = error { print("----------- 카카오 로그인 앱 에러:", error)
                    } else {
                        guard let oauthToken = oauthToken else { return  }
                        AuthAPI.shared.postSocialLogin(
                            social: "kakao", socialToken: oauthToken.accessToken, fcmToken: nil) { (kakaoData, err) in
                                guard let kakaoData = kakaoData else { return }
                                print("----------- 카카오 로그인 앱 :", kakaoData)
                                self.pushToHome()
                            }
                    }
                }
            }
        }
    }
    
    private func loginWithKakaoWeb() {
        UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
            if let error = error { print(error)
            } else {
                UserApi.shared.me {(user, error) in
                    if let error = error { print("----------- 카카오 로그인 웹 에러 :", error)
                    } else {
                        AuthAPI.shared.postSocialLogin(
                            social: "kakao", socialToken: oauthToken!.accessToken, fcmToken: nil) { (kakaoData, err) in
                                guard let kakaoData = kakaoData else { return }
                                print("----------- 카카오 로그인 웹 :", kakaoData)
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
        if let authorizationCode = appleIDCredential.authorizationCode,
           let identityToken = appleIDCredential.identityToken {
            
            let authString = String(data: authorizationCode, encoding: .utf8)
            let tokenString = String(data: identityToken, encoding: .utf8)
            
            guard let authString = authString else { return }
            guard let tokenString = tokenString else { return }
            print("인가코드", authString)
            print("토큰", tokenString)
            AuthAPI.shared.postSocialLogin(social: "apple", socialToken: tokenString, fcmToken: nil) { (appleData, err) in
                guard let appleData = appleData else { return }
                print("----------- 애플 로그인 :", appleData)
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
