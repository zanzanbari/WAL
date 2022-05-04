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
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                print(error)
            } else {
                UserApi.shared.me {(user, error) in
                    if let error = error {
                        print("ERROR : loginWithKakaoTalk() :", error)
                    } else {
                        self.pushToHome()
                        AuthAPI.shared.postSocialLogin(
                            social: "kakao", token: oauthToken!.accessToken) { model, data, err in
                                print("SUCCESS : loginWithKakaoTalk()")
                        }
                    }
                }
            }
        }
    }
    
    private func loginWithKakaoWeb() {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
            } else {
                UserApi.shared.me {(user, error) in
                    if let error = error {
                        print("ERROR : loginWithKakaoAccount()", error)
                    } else {
                        AuthAPI.shared.postSocialLogin(
                            social: "kakao", token: oauthToken!.accessToken) { model, data, err in
                            print("SUCCESS : loginWithKakaoAccount()")
                        }
                    }
                }
            }
        }
    }
}

// MARK: - 애플 로그인

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        if let authorizationCode = appleIDCredential.authorizationCode,
           let identityToken = appleIDCredential.identityToken {
            let authString = String(data: authorizationCode, encoding: .utf8)
            let tokenString = String(data: identityToken, encoding: .utf8)
            print("인증코드 및 유저토큰 문자열", authString as Any, tokenString as Any)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("ERROR : 애플아이디", error.localizedDescription)
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
