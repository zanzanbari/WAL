//
//  OnboardingCollectionViewCell.swift
//  WAL
//
//  Created by heerucan on 2022/04/30.
//

import UIKit

import Then
import WALKit

class OnboardingCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = Constant.onboardingCollectionViewCell
        
    // MARK: - Properties
    
    private let textCount: Int = 0
    private let maxLength: Int = 10
    
    private let titleLabel = UILabel().then {
        $0.font = WALFont.title2.font
        $0.text = "왈이 당신을 뭐라고 \n 부르면 되나요?"
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    private let subtitleLabel = UILabel().then {
        $0.font = WALFont.body7.font
        $0.text = "여보? 허니? 자기?"
        $0.numberOfLines = 0
    }
    
    public let nicknameTextField = WALTextField().then {
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
        $0.text = Constant.warnText
        $0.numberOfLines = 0
        $0.textColor = .red100
        $0.isHidden = true
    }
    
    public let nextButton = WALPlainButton().then {
        $0.title = "다음"
        $0.isDisabled = true
    }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupTextField()
        nicknameTextField.becomeFirstResponder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - InitUI
    
    private func setupLayout() {
        contentView.addSubviews([titleLabel,
                                 subtitleLabel,
                                 nicknameTextField,
                                 countLabel,
                                 warnIconView,
                                 warnLabel,
                                 nextButton])
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(UIScreen.main.hasNotch ? 16 : 23)
            make.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(9)
            make.centerX.equalToSuperview()
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(35)
            make.leading.trailing.equalToSuperview().inset(20)
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
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(UIScreen.main.hasNotch ? 50 : 26)
        }
    }
    
    private func setupTextField() {
        nicknameTextField.delegate = self
        nicknameTextField.becomeFirstResponder()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChange(_:)),
            name: UITextField.textDidChangeNotification,
            object: nicknameTextField)
    }
        
    // MARK: - @objc
    
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
        let offset = UIScreen.main.hasNotch ? 32.0 : 29.0
        UIView.animate(withDuration: 0.1) {
            self.nextButton.transform = CGAffineTransform(translationX: 0, y: offset-(self.keyboardHeight))
        }
    }
}

// MARK: - UITextFieldDelegate

extension OnboardingCollectionViewCell: UITextFieldDelegate {
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
        UIView.animate(withDuration: 0.25) {
            self.nextButton.transform = .identity
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = nicknameTextField.text else { return }
        if text.trimmingCharacters(in: .whitespaces).isEmpty || text == nicknameTextField.placeholder {
            nextButton.isDisabled = true
        } else {
            nextButton.isDisabled = false
        }
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
