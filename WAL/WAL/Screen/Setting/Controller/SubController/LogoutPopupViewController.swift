//
//  LogoutPopupViewController.swift
//  WAL
//
//  Created by heerucan on 2022/08/06.
//

import UIKit

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import Then
import WALKit

final class LogoutPopupViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var backPopupView = WALPopupView(title: Constant.Logout.title,
                                                  subTitle: Constant.Logout.subtitle,
                                                  rightButtonColor: .mint100).then {
        $0.leftText = Constant.Logout.left
        $0.rightText = Constant.Logout.right
        $0.leftButton.addTarget(self, action: #selector(touchupCancelButton), for: .touchUpInside)
        $0.rightButton.addTarget(self, action: #selector(touchupOkButton), for: .touchUpInside)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupLayout()
    }
    
    // MARK: - InitUI
    
    private func configUI() {
        view.backgroundColor = .black100.withAlphaComponent(0.5)
    }
    
    private func setupLayout() {
        view.addSubview(backPopupView)
        
        backPopupView.snp.makeConstraints {
            $0.height.equalTo(154)
            $0.width.equalTo(295)
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: - @objc
    
    @objc func touchupCancelButton() {
        dismiss(animated: false)
    }
    
    @objc func touchupOkButton() {
        TokenManager.shared.pushToLoginView()
    }
}
