//
//  MypageViewController.swift
//  WAL
//
//  Created by heerucan on 2022/06/27.
//

import UIKit

import Then
import WALKit

class MypageViewController: UIViewController, SendNicknameDelegate {
    
    // MARK: - Properties
    
    weak var sendNicknameDelegate: SendNicknameDelegate?
    
    var nickname = ""
    var email = ""
    
    private let navigationBar = WALNavigationBar(title: "내 정보").then {
        $0.backgroundColor = .white100
        $0.leftIcon = WALIcon.btnBack.image
        $0.leftBarButton.addTarget(self, action: #selector(touchupButton(_:)), for: .touchUpInside)
    }
    
    private lazy var backView = UIView().then {
        $0.backgroundColor = .white100
    }
        
    private let profileImageView = UIImageView().then {
        $0.image = WALIcon.icnProfile.image
    }
    
    private lazy var nicknameButton = UIButton().then {
        $0.setTitle(nickname, for: .normal)
        $0.setTitleColor(.black100, for: .normal)
        $0.setTitleColor(.gray600, for: .highlighted)
        $0.titleLabel?.font = WALFont.body6.font
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor.gray400.cgColor
        $0.layer.borderWidth = 1
        $0.addTarget(self, action: #selector(touchupButton(_:)), for: .touchUpInside)
    }
        
    private lazy var loginSubtitleLabel = UILabel().then {
        $0.font = WALFont.body9.font
        $0.textColor = .gray100
        if UserDefaultsHelper.standard.social == "kakao" {
            $0.text = "카카오 계정으로 로그인"
        } else if UserDefaultsHelper.standard.social == "apple" {
            $0.text = "애플 계정으로 로그인"
        }
    }
    
    private lazy var emailLabel = UILabel().then {
        $0.font = WALFont.body6.font
        $0.textColor = .black100
        if UserDefaultsHelper.standard.social == "kakao" {
            $0.text = email
        } else if UserDefaultsHelper.standard.social == "apple" {
            $0.text = "-"
        }
    }
    
    private let logoutButton = MenuButton(0).then {
        $0.addTarget(self, action: #selector(touchupButton(_:)), for: .touchUpInside)
    }
    
    private let resignButton = MenuButton(1).then {
        $0.addTarget(self, action: #selector(touchupButton(_:)), for: .touchUpInside)
    }

    private let firstLineView = UIView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupLayout()
    }
    
    // MARK: - InitUI
    
    private func configUI() {
        view.backgroundColor = .gray600
        backView.backgroundColor = .white100
        firstLineView.backgroundColor = .gray600
    }
    
    private func setupLayout() {
        view.addSubview(backView)
        backView.addSubviews([navigationBar,
                              profileImageView,
                              nicknameButton,
                              firstLineView,
                              loginSubtitleLabel,
                              emailLabel,
                              logoutButton,
                              resignButton])
        
        backView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(33)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(90)
        }
        
        nicknameButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(23)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        firstLineView.snp.makeConstraints { make in
            make.top.equalTo(nicknameButton.snp.bottom).offset(31)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(10)
        }
        
        loginSubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(firstLineView.snp.bottom).offset(17)
            make.leading.equalToSuperview().inset(20)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(loginSubtitleLabel.snp.bottom).offset(3)
            make.leading.equalToSuperview().inset(20)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
        }
        
        resignButton.snp.makeConstraints { make in
            make.top.equalTo(logoutButton.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - @objc
    
    @objc func touchupButton(_ sender: UIButton) {
        switch sender {
        case navigationBar.leftBarButton:
            sendNicknameDelegate?.sendNickname(nickname)
            transition(self, .pop)
        case nicknameButton:
            let viewController = EditNicknameViewController()
            viewController.modalPresentationStyle = .overFullScreen
            viewController.nickname = nickname
            viewController.sendNicknameDelegate = self
            present(viewController, animated: false)
        case resignButton:
            let viewController = ResignViewController()
            transition(viewController)
        default:
            let popupViewController = LogoutPopupViewController()
            popupViewController.modalPresentationStyle = .overFullScreen
            present(popupViewController, animated: false)
        }
    }
}

// MARK: - Protocol Method

extension MypageViewController {
    func sendNickname(_ nickname: String) {
        nicknameButton.setTitle(nickname, for: .normal)
        self.nickname = nickname
    }
}
