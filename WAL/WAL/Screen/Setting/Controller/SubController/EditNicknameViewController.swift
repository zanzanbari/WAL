//
//  EditNicknameViewController.swift
//  WAL
//
//  Created by heerucan on 2022/06/27.
//

import UIKit

import Then
import WALKit

final class EditNicknameViewController: BaseViewController {
    
    // MARK: - Properties
    
    weak var sendNicknameDelegate: SendNicknameDelegate?
    
    var nickname = ""
    private let textCount: Int = 0
    private let maxLength: Int = 10
    
    private let toolBar = UIToolbar()
    
    private let flexibleSpaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                                      target: nil,
                                                      action: nil)
    
    private lazy var doneToolButton = UIBarButtonItem(title: "완료",
                                                      style: .plain,
                                                      target: self,
                                                      action: #selector(touchupDoneButton))
    
    private let navigationBar = WALNavigationBar(title: "닉네임 수정").then {
        $0.backgroundColor = .white100
        $0.rightIcon = WALIcon.btnDelete.image
        $0.rightBarButton.addTarget(self, action: #selector(touchupCloseButton), for: .touchUpInside)
    }
    
    private let profileImageView = UIImageView().then {
        $0.image = WALIcon.icnProfile.image
    }
    
    private let nicknameTextField = WALTextField().then {
        $0.font = WALFont.body6.font
        $0.placeholder = "닉네임을 입력해주세요"
        $0.isFocusing = false
    }
    
    private lazy var countLabel = UILabel().then {
        $0.font = WALFont.body8.font
        $0.text = "\(textCount)/10"
        $0.textColor = .gray200
    }
    
    private let warnIconView = UIImageView().then {
        $0.image = WALIcon.icnWarning.image
        $0.isHidden = true
    }
    
    private let warnLabel = UILabel().then {
        $0.font = WALFont.body9.font
        $0.text = "띄어쓰기 없이 한글, 영문, 숫자만 가능해요"
        $0.numberOfLines = 0
        $0.textColor = .red100
        $0.isHidden = true
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupLayout()
        setupTextField()
    }
    
    // MARK: - InitUI
    
    private func configUI() {
        view.backgroundColor = .white
        toolBar.sizeToFit()
        toolBar.items = [flexibleSpaceButton,
                         doneToolButton]
        toolBar.tintColor = .black100
    }
    
    private func setupLayout() {
        view.addSubviews([navigationBar,
                          profileImageView,
                          nicknameTextField,
                          countLabel,
                          warnIconView,
                          warnLabel])
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(47)
            make.leading.trailing.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(33)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(90)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(23)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        warnIconView.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(2)
            make.leading.equalToSuperview().inset(19)
            make.width.height.equalTo(24)
        }
        
        warnLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(6)
            make.leading.equalTo(warnIconView.snp.trailing)
        }
        
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(6)
            make.trailing.equalToSuperview().inset(20)
        }
        
    }
    
    // MARK: - Custom Method
    
    private func setupTextField() {
        nicknameTextField.delegate = self
        nicknameTextField.becomeFirstResponder()
        nicknameTextField.inputAccessoryView = toolBar
        setupNotificationCenter()
    }
    
    override func setupNotificationCenter() {
        super.setupNotificationCenter()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChange(_:)),
            name: UITextField.textDidChangeNotification,
            object: nicknameTextField)
    }
    
    // MARK: - @objc
    
    @objc func touchupCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func textDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField,
           let text = textField.text {
            if text.count > maxLength {
                textField.deleteBackward()
            }
        }
    }
    
    @objc override func keyboardWillShow(_ notification: NSNotification) {
        super.keyboardWillShow(notification)
    }
    
    @objc private func touchupDoneButton() {
        guard let nickname = nicknameTextField.text else { return }
        SettingAPI.shared.postUserInfo(nickname: nickname) { (userInfoData, nil) in
            guard let userInfoData = userInfoData?.data else { return }
            self.nickname = userInfoData.nickname
            self.sendNicknameDelegate?.sendNickname(userInfoData.nickname)
        }
        self.view.endEditing(true)
        self.dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension EditNicknameViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        nicknameTextField.layer.borderColor = UIColor.orange100.cgColor
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        nicknameTextField.layer.borderColor = UIColor.gray400.cgColor
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        warnIconView.isHidden = true
        warnLabel.isHidden = true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = nicknameTextField.text else { return }
        countLabel.text = "\(text.count)/10"
        
        switch text.count {
        case 0...9:
            countLabel.addCharacterColor(color: .gray200, range: "\(text.count)")
        default:
            countLabel.addCharacterColor(color: .orange100, range: "\(text.count)")
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = nicknameTextField.text else { return false }
        let utf8Char = string.cString(using: .utf8)
        let isBackSpace = strcmp(utf8Char, "\\b")
        
        if string.hasCharacters() || isBackSpace == -92 {
            warnIconView.isHidden = true
            warnLabel.isHidden = true
            return true
        } else if text.trimmingCharacters(in: .whitespacesAndNewlines).count > 10 {
            return false
        } else {
            warnIconView.isHidden = false
            warnLabel.isHidden = false
            return false
        }
    }
}