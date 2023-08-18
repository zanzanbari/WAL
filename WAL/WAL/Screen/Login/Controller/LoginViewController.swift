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
import RxSwift
import Then
import WALKit

final class LoginViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let viewModel: LoginViewModel
    
    // MARK: - Properties
    
    private let logoImageView = GIFImageView().then {
        $0.animate(withGIFNamed: Constant.Login.gif, loopCount: 5)
    }
    
    private lazy var kakaoButton = WALAuthButton(type: .kakao).then {
        $0.addTarget(self, action: #selector(touchupKakaoButton), for: .touchUpInside)
        $0.alpha = 0
    }
    
    private lazy var appleButton = WALAuthButton(type: .apple).then {
        $0.addTarget(self, action: #selector(touchupAppleButton), for: .touchUpInside)
        $0.alpha = 0
    }
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupLayout()
        setLoginAnimation()
        bindViewModel()
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
    
    private func bindViewModel() {
        
    }
    
    private func pushToHome() {
        guard let nickname = UserDefaultsHelper.standard.nickname else { return }
        
        if nickname == Constant.Login.nickname {
            transition(OnboardingViewController(), .presentFullNavigation)
        } else {
            self.transition(MainViewController(), .presentFullNavigation)
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
    private func postLogin(socialToken: String, socialType: SocialType, fcmToken: String) {
        let param = LoginRequest(socialToken, socialType.rawValue, fcmToken)
        AuthAPI.shared.postLogin(param: param) { [weak self] (data, statusCode) in
            guard let self = self else { return }
            guard let _data = data else { return }
            guard let _statusCode = statusCode else { return }
            
            let networkResult = NetworkResult(rawValue: _statusCode) ?? .none
            
            UserDefaultsHelper.standard.nickname = _data.nickname
            UserDefaultsHelper.standard.socialtoken = socialToken
            UserDefaultsHelper.standard.social = socialType.rawValue
            
            switch networkResult {
            case .okay:
                self.pushToHome()
            default:
                self.showToast(message: "Error: \(_statusCode)")
            }
        }
    }
}

// MARK: - Kakao Login

extension LoginViewController {
    private func loginWithKakaoApp() {
        UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
            guard let self = self else { return }
            self.requestLogin(with: oauthToken)
        }
    }
    
    private func loginWithKakaoWeb() {
        UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
            guard let self = self else { return }
            self.requestLogin(with: oauthToken)
        }
    }
    
    private func requestLogin(with oauthToken: OAuthToken?) {
        UserApi.shared.me { (user, error) in
            if let error = error {
                self.showToast(message: "Error: \(error.localizedDescription)")
            } else {
                guard let oauthToken = oauthToken,
                      let fcmToken = UserDefaultsHelper.standard.fcmtoken else { return }
                self.postLogin(socialToken: oauthToken.accessToken, socialType: .KAKAO, fcmToken: fcmToken)
                UserDefaultsHelper.standard.email = user?.kakaoAccount?.email
            }
        }
    }
    
}

// MARK: - Apple Login

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        if let identityToken = appleIDCredential.identityToken {
            guard let tokenString = String(data: identityToken, encoding: .utf8),
                  let fcmToken = UserDefaultsHelper.standard.fcmtoken else { return }
            self.postLogin(socialToken: tokenString, socialType: .APPLE, fcmToken: fcmToken)
        }
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
