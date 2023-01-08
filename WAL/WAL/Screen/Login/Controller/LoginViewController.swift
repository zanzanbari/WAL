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
        $0.animate(withGIFNamed: Constant.Login.gif, loopCount: 5)
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
        guard let nickname = UserDefaultsHelper.standard.nickname else { return }
        print(nickname, "LoginView 닉네임==================")
        if nickname == "" {
            print("🛼 pushToHome() 로그인 후 온보딩을 완료하지 않아 온보딩뷰입니다.")
            transition(OnboardingViewController(), .presentFullNavigation)
        } else {
            // 로그인 -> 완료버튼을 눌러서 서버통신 성공인 경우에 -> 메인화면으로 이동
            print("🛼 pushToHome() \(nickname)님, 로그인 후 온보딩 완료 후 메인뷰입니다.")
            transition(MainViewController(), .presentFullNavigation)
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

// MARK: - Network

extension LoginViewController {
    func postSocialLogin(social: String, socialtoken: String, fcmtoken: String) {
        AuthAPI.shared.postSocialLogin(social: social, socialtoken: socialtoken,
            fcmtoken: fcmtoken) { [weak self] ( data, error) in
                guard let self = self else { return }
                if data!.status == 403 {
                    self.showAlert(title: Constant.Login.resign,
                                   message: nil,
                                   actions: [],
                                   cancelTitle: "확인",
                                   preferredStyle: .alert)
                } else {
                    guard let data = data,
                          let accessData = data.data else { return }
                    UserDefaultsHelper.standard.nickname = accessData.nickname
                    UserDefaultsHelper.standard.accesstoken = accessData.accesstoken
                    UserDefaultsHelper.standard.refreshtoken = accessData.refreshtoken
                    UserDefaultsHelper.standard.socialtoken = socialtoken
                    UserDefaultsHelper.standard.social = social
                    self.pushToHome()
                }
            }
    }
}

// MARK: - Kakao Login

extension LoginViewController {
    private func loginWithKakaoApp() {
        UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
            guard let self = self else { return }
            UserApi.shared.me { (user, error) in
                guard let oauthToken = oauthToken,
                      let fcmtoken = UserDefaultsHelper.standard.fcmtoken else { return }
                self.postSocialLogin(social: SocialType.kakao.rawValue,
                                     socialtoken: oauthToken.accessToken,
                                     fcmtoken: fcmtoken)
            }
        }
    }
    
    private func loginWithKakaoWeb() {
        UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
            UserApi.shared.me { [weak self] (user, error) in
                guard let self = self else { return }
                guard let oauthToken = oauthToken,
                      let fcmtoken = UserDefaultsHelper.standard.fcmtoken else { return }
                self.postSocialLogin(social: SocialType.kakao.rawValue,
                                     socialtoken: oauthToken.accessToken,
                                     fcmtoken: fcmtoken)
            }
        }
    }
}

// MARK: - Apple Login

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        if let identityToken = appleIDCredential.identityToken {
            let tokenString = String(data: identityToken, encoding: .utf8)
            guard let tokenString = tokenString,
                  let fcmtoken = UserDefaultsHelper.standard.fcmtoken else { return }
            self.postSocialLogin(social: SocialType.apple.rawValue,
                                 socialtoken: tokenString,
                                 fcmtoken: fcmtoken)            
        }
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
