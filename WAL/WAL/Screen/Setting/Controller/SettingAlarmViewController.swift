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
    
    private lazy var timeButtons = [morningButton, afternoonButton, nightButton]

    

    
    private let setting = SettingData()
    
    private lazy var navigationBar = WALNavigationBar(title: Constant.NavigationTitle.settingAlarm).then {
        $0.backgroundColor = .white100
        $0.leftIcon = WALIcon.btnBack.image
        $0.leftBarButton.addTarget(self, action: #selector(touchupBackButton), for: .touchUpInside)
    }
    
    private lazy var firstView = AlarmView(.firstMenu).then {
        $0.toggleSwitch.isOn = UserDefaultsHelper.standard.pushNoti
        $0.toggleSwitch.addTarget(self, action: #selector(switchValueChanged(toggle:)), for: .valueChanged)
    }
    
    private let backView = UIView().then {
        $0.backgroundColor = .gray600
    }
    
    private let titleLabel = UILabel().then {
        $0.text = Constant.SettingAlarm.title
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
        timeButtons.forEach {
            $0.addTarget(self, action: #selector(touchupButton(sender:)), for: .touchUpInside)
        }
    }
    
    private func setupLayout() {
        view.addSubviews([navigationBar, firstView, backView, titleLabel, alarmButtonStackView])
        alarmButtonStackView.addArrangedSubviews(timeButtons)
        
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
    
    private func showToastMessage() {
        let selectedButtons = timeButtons.filter {
            $0.layer.borderColor == UIColor.orange100.cgColor
        }
        if selectedButtons.count < 1 {
            showToast(message: Constant.Toast.selectOneMore)
        }
    }
    
    // MARK: - @objc
    
    @objc func touchupBackButton() {
        if morningButton.layer.borderColor == UIColor.gray400.cgColor &&
            afternoonButton.layer.borderColor == UIColor.gray400.cgColor &&
            nightButton.layer.borderColor == UIColor.gray400.cgColor {
            //            showToast(message: "1개 이상 선택해주세요")
        } else {
            postAlarm()
        }
    }
    
    @objc func touchupButton(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.layer.borderColor = sender.isSelected ?
        UIColor.orange100.cgColor : UIColor.gray400.cgColor
        showToastMessage()
    }
    
    @objc func switchValueChanged(toggle: UISwitch) {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
        UserDefaultsHelper.standard.pushNoti = toggle.isOn
        firstView.toggleSwitch.isOn = UserDefaultsHelper.standard.pushNoti
    }
}

// MARK: - Network

extension SettingAlarmViewController {
    private func updateButtonStates(data: [String]) {
        for (button, type) in zip(timeButtons, AlarmTimeType.allCases) {
            button.layer.borderColor = data.contains(type.rawValue)
            ? UIColor.orange100.cgColor : UIColor.gray400.cgColor
        }
    }
    
    private func requestAlarm() {
        SettingAPI.shared.getAlarm { [weak self] (data, status) in
            guard let self = self else { return }
            guard let data = data?.timeInfo else { return }
            updateButtonStates(data: data)
//            self.alarmBeforeChange = AlarmTime(data.morning, data.afternoon, data.night)
        }
    }
    
    private func postAlarm() {
        SettingAPI.shared.postAlarm(data: [
            alarmBeforeChange,
            AlarmTime(morningButton.isSelected, afternoonButton.isSelected, nightButton.isSelected)]) { [weak self] (userAlarmData, nil) in
                guard let self = self else { return }
                guard let userAlarm = userAlarmData,
                      let userAlarmData = userAlarm.timeInfo else { return }
//                if userAlarm.statusCode! < 400 {
//                    print("🥰 알림시간 수정 서버 통신 🥰", userAlarmData)
//                    self.morningButton.isSelected = userAlarmData.morning
//                    self.afternoonButton.isSelected = userAlarmData.afternoon
//                    self.nightButton.isSelected = userAlarmData.night
//                    if self.alarmBeforeChange.morning == self.morningButton.isSelected &&
//                        self.alarmBeforeChange.afternoon == self.afternoonButton.isSelected &&
//                        self.alarmBeforeChange.night == self.nightButton.isSelected {
//                        self.transition(self, .pop)
//                    } else {
//                        self.configureLoadingView()
//                        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
//                            self.loadingView.hide()
//                            self.transition(self, .pop)
//                        }
//                    }
//                } else {
//                    print("🥰 알림시간 수정 서버 통신 실패로 화면전환 실패")
//                }
            }
    }
}
