//
//  BaseViewController.swift
//  WAL
//
//  Created by heerucan on 2022/06/27.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - Properties
    
    var keyboardHeight: CGFloat = 0
    
    // MARK: - Initialize
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotificationCenter()
    }
    
    func setupNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
    }
    
    // MARK: - @objc
    
    @objc func keyboardWillShow(_ notification:NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.keyboardHeight = keyboardHeight
        }
    }
}

