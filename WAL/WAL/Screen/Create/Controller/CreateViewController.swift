//
//  CreateViewController.swift
//  WAL
//
//  Created by 배은서 on 2022/05/04.
//

import UIKit

import SnapKit
import Then
import WALKit
import Lottie

class CreateViewController: UIViewController {
    
    // MARK: - Properties
    
    private let navigationBar = WALNavigationBar(title: "왈소리 만들기").then {
        $0.leftIcon = WALIcon.btnBack.image
        $0.rightIcon = WALIcon.btnHistory.image
    }
    
    private let walSoundLabel = UILabel().then {
        $0.text = "왈소리"
        $0.font = WALFont.body2.font
        $0.textColor = UIColor.black100
    }
    
    private let informationButton = UIButton().then {
        $0.setImage(WALIcon.btnInfo.image, for: .normal)
    }
    
    private lazy var walSoundTextView = UITextView().then {
        $0.font = WALFont.body5.font
        $0.textColor = UIColor.black100
        $0.textContainerInset = UIEdgeInsets(top: 17, left: 17, bottom: 17, right: 17)
        $0.isScrollEnabled = false
        $0.layer.borderColor = UIColor.gray500.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        
        $0.delegate = self
    }
    
    private let placeholderLabel = UILabel().then {
        $0.font = WALFont.body5.font
        $0.textColor = UIColor.gray300
        $0.text = "내가 받을 왈소리를 작성해주세요"
    }
    
    private let countLabel = UILabel().then {
        $0.text = "0"
    }
    
    private let maximumCountLabel = UILabel().then {
        $0.text = "/100"
    }
    
    private let reservationTimeView = UIView().then {
        $0.backgroundColor = UIColor.gray600
        $0.layer.cornerRadius = 10
    }
    
    private let reservationTimeLabel = UILabel().then {
        $0.text = "예약 시간"
        $0.font = WALFont.body4.font
        $0.textColor = UIColor.black100
    }
    
    // button configuration 사용해
    private let hideHistoryButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.title = "도착할 때까지 히스토리에서 가리기"
        config.image = WALIcon.btnUnselect.image
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer {
            var title = $0
            title.foregroundColor = UIColor.black100
            title.font = WALFont.body7.font
            return title
        }
        
        $0.configuration = config
        $0.addTarget(self, action: #selector(touchupHideHistoryButton), for: .touchUpInside)
    }
    
    private let sendButton = UIButton().then {
        $0.titleLabel?.font = WALFont.body1.font
        $0.setTitle("보내기", for: .normal)
        $0.setTitleColor(UIColor.white100, for: .normal)
        $0.backgroundColor = UIColor.gray400
        $0.layer.cornerRadius = 22
    }
    
    private lazy var countStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 0
        $0.addArrangedSubviews([countLabel, maximumCountLabel])
    }
    
    private var isSelectedHideHistory = false {
        didSet {
            isSelectedHideHistory == false ? hideHistoryButton.setImage(WALIcon.btnUnselect.image, for: .normal) : hideHistoryButton.setImage(WALIcon.btnSelect.image, for: .normal)
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupLayout()
    }
    
    // MARK: - InitUI
    
    private func configUI() {
        self.navigationController?.navigationBar.isHidden = true
        
        [countLabel, maximumCountLabel].forEach {
            $0.font = WALFont.body8.font
            $0.textColor = UIColor.gray200
        }
    }
    
    private func setupLayout() {
        view.addSubviews([navigationBar,
                          walSoundLabel,
                          informationButton,
                          walSoundTextView,
                          placeholderLabel,
                          countStackView,
                          hideHistoryButton,
                          reservationTimeView,
                          reservationTimeLabel,
                          sendButton])
        
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.layoutMarginsGuide)
        }
        
        walSoundLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(33)
            $0.leading.equalToSuperview().inset(20)
        }
        
        informationButton.snp.makeConstraints {
            $0.centerY.equalTo(walSoundLabel.snp.centerY)
            $0.leading.equalTo(walSoundLabel.snp.trailing)
        }
        
        walSoundTextView.snp.makeConstraints {
            $0.top.equalTo(walSoundLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(161)
        }
        
        placeholderLabel.snp.makeConstraints {
            $0.top.leading.equalTo(walSoundTextView).inset(17)
        }
        
        countStackView.snp.makeConstraints {
            $0.bottom.equalTo(walSoundTextView.snp.bottom).inset(10)
            $0.trailing.equalTo(walSoundTextView.snp.trailing).inset(17)
        }
        
        hideHistoryButton.snp.makeConstraints {
            $0.top.equalTo(walSoundTextView.snp.bottom)
            $0.leading.equalToSuperview()
        }
        
        reservationTimeView.snp.makeConstraints {
            $0.top.equalTo(hideHistoryButton.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(54)
        }
        
        reservationTimeLabel.snp.makeConstraints {
            $0.top.leading.equalTo(reservationTimeView).inset(18)
        }
        
        sendButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.layoutMarginsGuide).inset(11)
            $0.height.equalTo(52)
        }
    }
    
    //MARK: - @objc
    
    @objc private func touchupHideHistoryButton() {
        isSelectedHideHistory.toggle()
    }
    
    // MARK: - Custom Method
    
    
}

extension CreateViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        walSoundTextView.layer.borderColor = UIColor.gray500.cgColor
        
        (walSoundTextView.text.count == 0) ? (placeholderLabel.isHidden = false) : (placeholderLabel.isHidden = true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        walSoundTextView.layer.borderColor = UIColor.orange100.cgColor
        placeholderLabel.isHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        countLabel.text = "\(walSoundTextView.text.count)"
        
        if walSoundTextView.text.count > 100 {
            walSoundTextView.deleteBackward()
            countLabel.textColor = UIColor.orange100
        } else {
            countLabel.textColor = UIColor.gray200
        }
    }
}
