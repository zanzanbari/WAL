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
    
    public var timeButtonArray: [UIButton] = []
    
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
    
    public let completeButton = WALPlainButton().then {
        $0.title = "완료"
        $0.isDisabled = true
    }
    
    private lazy var alarmButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        $0.spacing = 16
    }
    
    private let moringButtoon = TimeButton("아침", WALIcon.icnMorning.image)
    private let lauchButton = TimeButton("점심", WALIcon.icnLaunch.image)
    private let eveningButton = TimeButton("저녁", WALIcon.icnEvening.image)
    
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
        [moringButtoon, lauchButton, eveningButton].forEach {
            $0.addTarget(self, action: #selector(touchupButton(sender:)), for: .touchUpInside)
        }
    }
    
    private func setupLayout() {
        contentView.addSubviews([titleLabel,
                                 subtitleLabel,
                                 alarmButtonStackView,
                                 completeButton])
        
        alarmButtonStackView.addArrangedSubviews([moringButtoon, lauchButton, eveningButton])
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
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
        
        [moringButtoon, lauchButton, eveningButton].forEach {
            $0.snp.makeConstraints { make in
            make.width.equalTo(101)
            make.height.equalTo(104)
        } }
        
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(50)
        }
    }

    // MARK: - Custom Method
    
    // MARK: - @objc
    
    @objc func touchupButton(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.layer.borderColor = sender.isSelected ? UIColor.orange100.cgColor : UIColor.gray400.cgColor
        
        completeButton.isDisabled =
        moringButtoon.layer.borderColor == UIColor.gray400.cgColor &&
        lauchButton.layer.borderColor == UIColor.gray400.cgColor &&
        eveningButton.layer.borderColor == UIColor.gray400.cgColor ? true : false
    }
}