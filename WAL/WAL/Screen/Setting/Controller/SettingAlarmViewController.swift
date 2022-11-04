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
    
    private var alarmBeforeChange = AlarmTime.init(false, false, false)
    
    private let setting = SettingData()
    
    private let navigationBar = WALNavigationBar(title: "알림").then {
        $0.backgroundColor = .white100
        $0.leftIcon = WALIcon.btnBack.image
        $0.leftBarButton.addTarget(self, action: #selector(touchupBackButton), for: .touchUpInside)
    }
    
    private lazy var firstView = AlarmView(.firstMenu).then {
        let isPushNotificationOn = UIApplication.shared.isRegisteredForRemoteNotifications
        $0.toggleSwitch.isOn = isPushNotificationOn
        $0.toggleSwitch.addTarget(self, action: #selector(switchValueChanged(toggle:)), for: .valueChanged)
    }
    
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
    
    private let loadingView = LoadingView()
    
    private let morningButton = TimeButton(0)
    private let afternoonButton = TimeButton(1)
    private let nightButton = TimeButton(2)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestAlarm()
        configUI()
        setupLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    // MARK: - InitUI
    
    private func configUI() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        view.backgroundColor = .white100
        [morningButton, afternoonButton, nightButton].forEach {
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
            make.top.equalTo(view.safeAreaLayoutGuide)
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
    
    // MARK: - Custom Method
    
    private func configureLoadingView() {
        let loadingView = LoadingView()
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        loadingView.play()
    }
    
    // MARK: - @objc
    
    @objc func touchupBackButton() {
        if morningButton.layer.borderColor == UIColor.gray400.cgColor &&
            afternoonButton.layer.borderColor == UIColor.gray400.cgColor &&
            nightButton.layer.borderColor == UIColor.gray400.cgColor {
            showToast(message: "1개 이상 선택해주세요")
        } else {
            postAlarm()
        }
    }
    
    @objc func touchupButton(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.layer.borderColor = sender.isSelected ?
        UIColor.orange100.cgColor : UIColor.gray400.cgColor
    }
    
    @objc func switchValueChanged(toggle: UISwitch) {
        if toggle.isOn {
            UIApplication.shared.registerForRemoteNotifications()
        } else {
            UIApplication.shared.unregisterForRemoteNotifications()
        }
    }
}

// MARK: - Network

extension SettingAlarmViewController {
    private func buttonBorderColor(_ button: UIButton, _ userTimeData: Bool) {
        button.isSelected = userTimeData
        button.layer.borderColor = button.isSelected ?
        UIColor.orange100.cgColor : UIColor.gray400.cgColor
    }
    
    private func requestAlarm() {
        SettingAPI.shared.getUserAlarm { [weak self] (userAlarmData, nil) in
            guard let self = self else { return }
            guard let userAlarmData = userAlarmData?.data else { return }
            print("🥰 알림시간 값 가져오기 🥰", userAlarmData)
            self.buttonBorderColor(self.morningButton, userAlarmData.morning)
            self.buttonBorderColor(self.afternoonButton, userAlarmData.afternoon)
            self.buttonBorderColor(self.nightButton, userAlarmData.night)
            self.alarmBeforeChange = AlarmTime(userAlarmData.morning, userAlarmData.afternoon, userAlarmData.night)
        }
    }
    
    private func postAlarm() {
        SettingAPI.shared.postUserAlarm(data: [
            alarmBeforeChange,
            AlarmTime(morningButton.isSelected, afternoonButton.isSelected, nightButton.isSelected)]) { [weak self] (userAlarmData, nil) in
                guard let self = self else { return }
                guard let userAlarm = userAlarmData,
                      let userAlarmData = userAlarm.data else { return }
                if userAlarm.status < 400 {
                    print("🥰 알림시간 수정 서버 통신 🥰", userAlarmData)
                    self.morningButton.isSelected = userAlarmData.morning
                    self.afternoonButton.isSelected = userAlarmData.afternoon
                    self.nightButton.isSelected = userAlarmData.night
                    if self.alarmBeforeChange.morning == self.morningButton.isSelected &&
                        self.alarmBeforeChange.afternoon == self.afternoonButton.isSelected &&
                        self.alarmBeforeChange.night == self.nightButton.isSelected {
                        self.transition(self, .pop)
                    } else {
                        self.configureLoadingView()
                        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                            self.loadingView.hide()
                            self.transition(self, .pop)
                        }
                    }
                } else {
                    print("🥰 알림시간 수정 서버 통신 실패로 화면전환 실패")
                }
            }
    }
}
