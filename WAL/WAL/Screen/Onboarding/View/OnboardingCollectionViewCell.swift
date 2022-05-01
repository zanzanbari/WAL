//
//  OnboardingCollectionViewCell.swift
//  WAL
//
//  Created by heerucan on 2022/04/30.
//

import UIKit

import Then
import WALKit

class OnboardingCollectionViewCell: UICollectionViewCell {
        
    // MARK: - Properties
    
    private let textCount: Int = 0
    
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
    }
    
    private let warnLabel = UILabel().then {
        $0.font = WALFont.body9.font
        $0.text = "띄어쓰기 없이 한글, 영문, 숫자만 가능해요"
        $0.numberOfLines = 0
        $0.textColor = .red100
    }
    
    private let nextButton = WALPlainButton().then {
        $0.title = "다음"
        $0.isDisabled = true
    }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
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
                                 nextButton])
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
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
        
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(6)
            make.trailing.equalToSuperview().inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(21)
            make.bottom.equalToSuperview().inset(50)
        }
    }
    
    // MARK: - Custom Method

}
