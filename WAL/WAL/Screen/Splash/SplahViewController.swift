//
//  SplahViewController.swift
//  WAL
//
//  Created by heerucan on 2022/12/23.
//

import UIKit

import WALKit
import Then

final class SplashViewController: BaseViewController {
    
    // MARK: - Property
    
    private let logoImageView = UIImageView().then {
        $0.image = WALIcon.icnWal.image
        $0.alpha = 0
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
        configureAnimation()
    }
    
    // MARK: - UI & Layout
    
    private func configureUI() {
        view.backgroundColor = .orange100
    }
    
    private func configureLayout() {
        view.addSubview(logoImageView)
        
        logoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(250)
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - Custom Method
    
    private func configureAnimation() {
        UIView.animate(withDuration: 2, delay: 1) {
            self.logoImageView.alpha = 1
        
        } completion: { [weak self] _ in
            guard let self = self else { return }
            guard let accesstoken = UserDefaultsHelper.standard.accesstoken else { return }
            print("🛼", UserDefaultsHelper.standard.complete, accesstoken)
            
            if accesstoken == "" {
                print("🛼 scene() 로그인이 완료되지 않아 로그인뷰입니다.")
                let viewController = LoginViewController()
                viewController.modalPresentationStyle = .fullScreen
                viewController.modalTransitionStyle = .crossDissolve
                self.present(viewController, animated: false, completion: nil)
                
            } else {
                // 액세스토큰 O -> 자동로그인 -> 근데 아직 온보딩화면을 완료X
                if UserDefaultsHelper.standard.complete == false {
                    print("🛼 scene() 자동로그인 후 온보딩을 완료하지 않아서 온보딩뷰입니다.")
                    let viewController = UINavigationController(rootViewController: OnboardingViewController())
                    viewController.modalPresentationStyle = .fullScreen
                    viewController.modalTransitionStyle = .crossDissolve
                    self.present(viewController, animated: false, completion: nil)
                    
                } else {
                    // 액세스토큰 O -> 자동로그인 -> 완료버튼을 눌러서 서버통신 성공인 경우에 -> 메인화면으로 이동
                    print("🛼 scene() 자동로그인 후 온보딩 완료해서 메인뷰입니다.")
                    let viewController = UINavigationController(rootViewController: MainViewController(viewModel: .init()))
                    viewController.modalPresentationStyle = .fullScreen
                    viewController.modalTransitionStyle = .crossDissolve
                    self.present(viewController, animated: false, completion: nil)
                }
            }
        }
    }
}
