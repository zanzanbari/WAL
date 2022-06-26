//
//  SettingAlarmViewController.swift
//  WAL
//
//  Created by heerucan on 2022/05/08.
//

import UIKit

import WALKit

final class SettingAlarmViewController: UIViewController {
    
    // MARK: - Properties
    
    private let setting = SettingData()
    
    private let navigationBar = WALNavigationBar(title: "알림").then {
        $0.backgroundColor = .white100
        $0.leftIcon = WALIcon.btnBack.image
        $0.leftBarButton.addTarget(self, action: #selector(touchupBackButton), for: .touchUpInside)
    }
    
    private lazy var firstView = AlarmView(.firstMenu)
        
    private let backView = UIView().then {
        $0.backgroundColor = .gray600
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "왈소리 받는 시간"
        $0.font = WALFont.body6.font
        $0.textColor = .black100
    }
    
    private lazy var alarmButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 16
    }
    
    private let moringButtoon = TimeButton(0)
    private let lauchButton = TimeButton(1)
    private let eveningButton = TimeButton(2)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupLayout()
    }
    
    // MARK: - InitUI
    
    private func configUI() {
        view.backgroundColor = .white100
        [moringButtoon, lauchButton, eveningButton].forEach {
            $0.addTarget(self, action: #selector(touchupButton(sender:)), for: .touchUpInside)
        }
    }
    
    private func setupLayout() {
        view.addSubviews([navigationBar,
                          firstView,
                          backView,
                          titleLabel,
                          alarmButtonStackView])
        alarmButtonStackView.addArrangedSubviews([moringButtoon, lauchButton, eveningButton])
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(47)
            make.leading.trailing.equalToSuperview()
        }
        
        firstView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        backView.snp.makeConstraints { make in
            make.top.equalTo(firstView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backView.snp.bottom).offset(23)
            make.leading.equalToSuperview().inset(20)
        }
        
        alarmButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(104)
        }
        
        [moringButtoon, lauchButton, eveningButton].forEach {
            $0.snp.makeConstraints { make in
            make.height.equalTo(104)
        } }
    }

    // MARK: - @objc
    
    @objc func touchupBackButton() {
        if moringButtoon.layer.borderColor == UIColor.gray400.cgColor &&
            lauchButton.layer.borderColor == UIColor.gray400.cgColor &&
            eveningButton.layer.borderColor == UIColor.gray400.cgColor {
            showToast(message: "1개 이상 선택해주세요")
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
        
    @objc func touchupButton(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.layer.borderColor = sender.isSelected ? UIColor.orange100.cgColor : UIColor.gray400.cgColor
    }
}
