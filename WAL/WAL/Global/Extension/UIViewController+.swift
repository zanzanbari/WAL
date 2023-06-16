//
//  UIViewController+.swift
//  WAL
//
//  Created by heerucan on 2022/05/02.
//

import UIKit
import WALKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = true
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2-125,
                                               y: self.view.frame.size.height-50,
                                               width: 250, height: 33)).then {
            $0.backgroundColor = .black100.withAlphaComponent(0.6)
            $0.backgroundColor = .black100.withAlphaComponent(0.6)
            $0.textColor = .white100
            $0.font = WALFont.body8.font
            $0.textAlignment = .center
            $0.text = message
            $0.layer.cornerRadius = 16.5
            $0.clipsToBounds  =  true
            self.view.addSubview($0)
        }
        
        UIView.animate(withDuration: 1.5, delay: 0.2, options: .curveEaseIn) {
            toastLabel.alpha = 0.0
        } completion: { _ in
            toastLabel.removeFromSuperview()
        }
    }
    
    func configureCellBackgroundColor(_ cell: UITableViewCell) {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .gray600
        cell.selectedBackgroundView = backgroundView
    }
    
    func showAlert(title: String? = nil,
                   message: String? = nil,
                   actions: [UIAlertAction] = [],
                   cancelTitle: String? = "취소",
                   preferredStyle: UIAlertController.Style = .actionSheet) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: preferredStyle)
        let cancel = UIAlertAction(title: cancelTitle, style: .cancel)
        actions.forEach { alert.addAction($0) }
        alert.addAction(cancel)
        transition(alert, .present)
    }
}

extension UIViewController {
    /// 로그인 화면으로 이동 (소셜 토큰 만료 등)
    func pushToLoginView() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        let viewController = LoginViewController(viewModel: LoginViewModel())
        sceneDelegate?.window?.rootViewController = viewController
        sceneDelegate?.window?.makeKeyAndVisible()
        UserDefaultsHelper.standard.removeAccessToken()
    }
}

extension UIViewController {
    /// 네트워크 연결 유실 시 alert 
    func showNetworkAlert() {
        let errorTitle = "네트워크 연결"
        let errorMsg = "네트워크 연결상태를\n확인 후 다시 시도해 주세요."
        
        let alert = UIAlertController(title: errorTitle, message: errorMsg, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "확인", style: .destructive) { _ in
            exit(0)
        }
        
        alert.addAction(defaultAction)
        present(alert, animated: true)
    }
}
