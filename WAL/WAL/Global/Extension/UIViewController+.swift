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
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75,
                                               y: self.view.frame.size.height-106,
                                               width: 150, height: 33)).then {
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
}
