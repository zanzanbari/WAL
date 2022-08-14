//
//  SettingAlarmViewController.swift
//  WAL
//
//  Created by heerucan on 2022/05/08.
//

import UIKit

import Then
import WALKit

final class SettingAlarmViewController: UIViewController {
    
    // MARK: - Properties
    
    // 바꾸기 이전 값을 저장하기 위한 프로퍼티 선언
    private var morningBeforeReplacment = false
    private var afternoonBeforeReplacment = false
    private var nightBeforeReplacment = false
    
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
    
    private let morningButton = TimeButton(0)
    private let afternoonButton = TimeButton(1)
    private let nightButton = TimeButton(2)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestTime()
        configUI()
        setupLayout()
    }
    
    // MARK: - InitUI
    
    private func configUI() {
        view.backgroundColor = .white100
        [morningButton,
         afternoonButton,
         nightButton].forEach {
            $0.addTarget(self, action: #selector(touchupButton(sender:)), for: .touchUpInside)
        }
    }
    
    private func setupLayout() {
        view.addSubviews([navigationBar,
                          firstView,
                          backView,
                          titleLabel,
                          alarmButtonStackView])
        alarmButtonStackView.addArrangedSubviews([morningButton,
                                                  afternoonButton,
                                                  nightButton])
        
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
        
        [morningButton, afternoonButton, nightButton].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(104)
            }
        }
    }
    
    // MARK: - @objc
    
    @objc func touchupBackButton() {
        if morningButton.layer.borderColor == UIColor.gray400.cgColor &&
            afternoonButton.layer.borderColor == UIColor.gray400.cgColor &&
            nightButton.layer.borderColor == UIColor.gray400.cgColor {
            showToast(message: "1개 이상 선택해주세요")
        } else {
            postTime()
        }
    }
    
    @objc func touchupButton(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.layer.borderColor = sender.isSelected ?
        UIColor.orange100.cgColor : UIColor.gray400.cgColor
    }
}

// MARK: - Network

extension SettingAlarmViewController {
    private func buttonBorderColor(_ button: UIButton) {
        if button.isSelected {
            button.layer.borderColor = UIColor.orange100.cgColor
        } else {
            button.layer.borderColor = UIColor.gray400.cgColor
        }
    }
    
    private func requestTime() {
        SettingAPI.shared.getUserTime { (userTimeData, nil) in
            guard let userTimeData = userTimeData?.data else { return }
            print("🥰 알림시간 값 가져오기",userTimeData)
            // MARK: - TODO 코드 개선
            self.morningButton.isSelected = userTimeData.morning
            self.afternoonButton.isSelected = userTimeData.afternoon
            self.nightButton.isSelected = userTimeData.night
            self.buttonBorderColor(self.morningButton)
            self.buttonBorderColor(self.afternoonButton)
            self.buttonBorderColor(self.nightButton)
            self.morningBeforeReplacment = userTimeData.morning
            self.afternoonBeforeReplacment = userTimeData.afternoon
            self.nightBeforeReplacment = userTimeData.night
        }
    }
    
    private func postTime() {
        SettingAPI.shared.postUserTime(data: [
            // 바꾸기 이전 값
            AlarmTime(morningBeforeReplacment, afternoonBeforeReplacment, nightBeforeReplacment),
            // 바꾼 이후 값
            AlarmTime(morningButton.isSelected, afternoonButton.isSelected, nightButton.isSelected)]) { (userTimeData, nil) in
                guard let userTime = userTimeData,
                      let userTimeData = userTime.data else { return }
                if userTime.status < 400 {
                    print("🥰 알림시간 수정 서버 통신",userTimeData)
                    self.morningButton.isSelected = userTimeData.morning
                    self.afternoonButton.isSelected = userTimeData.afternoon
                    self.nightButton.isSelected = userTimeData.night
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print("🥰 알림시간 수정 서버 통신 실패로 화면전환 실패")
                }
            }
    }
}
