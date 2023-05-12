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
    
    // TODO: - 해결 연결 넘어가는 것 닉네임이 없음
    private func pushToHome() {
        guard let nickname = UserDefaultsHelper.standard.nickname else { return }
        print("LoginView 닉네임 : \(nickname)==================")
        if nickname == "" {
            print("🛼 pushToHome() 로그인 후 온보딩을 완료하지 않아 온보딩뷰입니다.")
            transition(OnboardingViewController(), .presentFullNavigation)
        } else {
            // 로그인 -> 완료버튼을 눌러서 서버통신 성공인 경우에 -> 메인화면으로 이동
            print("🛼 pushToHome() \(nickname)님, 로그인 후 온보딩 완료 후 메인뷰입니다.")
            transition(MainViewController(viewModel: .init()), .presentFullNavigation)
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
        AuthAPI.shared.postLogin(param: param) { [weak self] ( data, status) in
            guard let self = self else { return }
            guard let status = status else { return }
            if status == 403 {
                self.showAlert(title: Constant.Login.resign,
                               message: nil,
                               actions: [],
                               cancelTitle: "확인",
                               preferredStyle: .alert)
            } else {
                UserDefaultsHelper.standard.socialtoken = socialToken
                UserDefaultsHelper.standard.social = socialType.rawValue
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
                      let fcmToken = UserDefaultsHelper.standard.fcmtoken else { return }
                self.postLogin(socialToken: oauthToken.accessToken, socialType: .KAKAO, fcmToken: fcmToken)
                UserDefaultsHelper.standard.email = user?.kakaoAccount?.email
            }
        }
    }
    
    private func loginWithKakaoWeb() {
        UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
            UserApi.shared.me { [weak self] (user, error) in
                guard let self = self else { return }
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
