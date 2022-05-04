//
//  LoginViewController.swift
//  WAL
//
//  Created by heerucan on 2022/05/04.
//

import UIKit

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
    }
    
    private let appleButton = WALAuthButton().then {
        $0.authType = .apple
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


}
