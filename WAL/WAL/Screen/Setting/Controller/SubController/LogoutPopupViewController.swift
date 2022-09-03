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
    
    private lazy var backPopupView = WALPopupView(title: "로그아웃",
                                                  subTitle: "정말 로그아웃 하시겠어요?",
                                                  rightButtonColor: .mint100).then {
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
    
    // MARK: - Custom Method
    
    func pushToLoginView() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        let viewController = LoginViewController()
        sceneDelegate?.window?.rootViewController = viewController
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    // MARK: - @objc
    
    @objc func touchupCancelButton() {
        dismiss(animated: false)
    }
    
    @objc func touchupOkButton() {
        AuthAPI.shared.getLogout { logoutData, err in
            guard let logoutData = logoutData else { return }
            if logoutData.status < 400 {
                print("☘️--------로그아웃 서버 통신 : ", logoutData)
                self.pushToLoginView()
            } else {
                print("☘️--------로그아웃 서버 통신 실패로 화면 전환 실패")
            }
        }
    }
}
