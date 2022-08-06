//
//  LogoutPopupViewController.swift
//  WAL
//
//  Created by heerucan on 2022/08/06.
//

import UIKit

import Then
import WALKit

final class LogoutPopupViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var backPopupView = WALPopupView(title: "로그아웃", subTitle: "정말 로그아웃 하시겠어요?", rightButtonColor: .mint100).then {
        $0.leftText = "취소"
        $0.rightText = "로그아웃"
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
        dismiss(animated: true)
    }
    
    @objc func touchupOkButton() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        let viewController = UINavigationController(rootViewController: LoginViewController())
        sceneDelegate?.window?.rootViewController = viewController
        sceneDelegate?.window?.makeKeyAndVisible()
    }
}
