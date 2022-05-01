//
//  AuthViewController.swift
//  WAL
//
//  Created by heerucan on 2022/05/01.
//

import UIKit

import SnapKit
import Then

final class AuthViewController: UIViewController {

    // MARK: - Properties
    
    private let appleLoginButton = WALAuthButton().then {
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
        view.addSubview(appleLoginButton)
        
        appleLoginButton.snp.makeConstraints { make in
            make.top.equalTo(100)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - Custom Method

}
