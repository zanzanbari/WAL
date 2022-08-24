//
//  AlarmCollectionViewCell.swift
//  WAL
//
//  Created by heerucan on 2022/05/02.
//

import UIKit

import Then
import WALKit

class AlarmCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Properties
        
    weak var sendAlarmTimeDelegate: SendAlarmTimeDelegate?

    private let timeData = TimeData()
    
    private let titleLabel = UILabel().then {
        $0.font = WALFont.title2.font
        $0.text = "언제 알림이 \n 울리길 원하나요?"
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    private let subtitleLabel = UILabel().then {
        $0.font = WALFont.body7.font
        $0.text = "다중선택 가능해요"
        $0.numberOfLines = 0
    }
    
    let completeButton = WALPlainButton().then {
        $0.title = "완료"
        $0.isDisabled = true
    }
    
    private lazy var alarmButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 16
    }
    
    private let moringButtoon = TimeButton(0)
    private let afternoonButton = TimeButton(1)
    private let nightButton = TimeButton(2)
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - InitUI
    
    private func configUI() {
        contentView.backgroundColor = .white100
        [moringButtoon, afternoonButton, nightButton].forEach {
            $0.addTarget(self, action: #selector(touchupButton(sender:)), for: .touchUpInside)
        }
    }
    
    private func setupLayout() {
        contentView.addSubviews([titleLabel,
                                 subtitleLabel,
                                 alarmButtonStackView,
                                 completeButton])
        
        alarmButtonStackView.addArrangedSubviews([moringButtoon, afternoonButton, nightButton])
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(UIScreen.main.hasNotch ? 16 : 23)
            make.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(9)
            make.centerX.equalToSuperview()
        }

        alarmButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(35)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(104)
        }
        
        [moringButtoon, afternoonButton, nightButton].forEach {
            $0.snp.makeConstraints { make in
            make.height.equalTo(104)
        } }
        
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(UIScreen.main.hasNotch ? 50 : 26)
        }
    }
    
    // MARK: - @objc
    
    @objc func touchupButton(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.layer.borderColor = sender.isSelected
        ? UIColor.orange100.cgColor : UIColor.gray400.cgColor
        
        completeButton.isDisabled =
        moringButtoon.layer.borderColor == UIColor.gray400.cgColor &&
        afternoonButton.layer.borderColor == UIColor.gray400.cgColor &&
        nightButton.layer.borderColor == UIColor.gray400.cgColor ? true : false
        
        sendAlarmTimeDelegate?.sendAlarmTime(
            morning: moringButtoon.isSelected,
            afternoon: afternoonButton.isSelected,
            night: nightButton.isSelected)
    }
}
