//
//  Transition+.swift
//  WAL
//
//  Created by heerucan on 2022/08/27.
//

import UIKit

extension UIViewController {
    enum TransitionStyle {
        case presentNavigation // 네비게이션 임베드 present
        case present // 네비게이션 없이 present
        case presentFullNavigation // 네비게이션 풀스크린
        case push
        case dismiss
        case presentedViewDismiss // presentingViewController 보여주기
        case pop
    }
    
    func transition<T: UIViewController>(_ viewController: T,
                                         _ style: TransitionStyle = .push,
                                         completion: ((T) -> Void)? = nil) {
        
        completion?(viewController)
        
        switch style {
        case .presentNavigation:
            let navi = UINavigationController(rootViewController: viewController)
            viewController.modalPresentationStyle = .fullScreen
            self.present(navi, animated: true)
            
        case .present:
            self.present(viewController, animated: true)
            
        case .push:
            self.navigationController?.pushViewController(viewController, animated: true)
            
        case .presentFullNavigation:
            let navi = UINavigationController(rootViewController: viewController)
            navi.modalPresentationStyle = .fullScreen
            self.present(navi, animated: true)
            
        case .dismiss:
            self.dismiss(animated: true)
            
        case .presentedViewDismiss:
            self.dismiss(animated: true) {
                viewController.viewWillAppear(true)
            }
            
        case .pop:
            navigationController?.popViewController(animated: true)
        }
    }
}
