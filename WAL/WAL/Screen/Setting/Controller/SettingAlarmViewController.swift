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
        getAlarm()
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
        
        timeButtons.forEach {
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
        let selectedButtons = timeButtons.filter { $0.isSelected }
        if selectedButtons.count < 1 {
            showToast(message: Constant.Toast.selectOneMore)
        }
    }
    
    // MARK: - @objc
    
    @objc func touchupBackButton() {
        postAlarm()
    }
    
    @objc func touchupButton(sender: TimeButton) {
        sender.isSelected = !sender.isSelected
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
            button.isSelected = data.contains(type.rawValue) ? true : false
        }
    }
    
    private func getAlarm() {
        SettingAPI.shared.getAlarm { [weak self] (data, status) in
            guard let self = self else { return }
            guard let data = data?.timeInfo else { return }
            updateButtonStates(data: data)
        }
    }
    
    private func postAlarm() {
        let selectedButtons = timeButtons.filter { $0.isSelected }
        let data = selectedButtons.map { $0.data.getTime(index: $0.tag) }
        
        SettingAPI.shared.postAlarm(data: data) { [weak self] (data, status) in
            guard let self else { return }
            guard let status = status else { return }
            if status == 204 {
                self.configureLoadingView()
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    self.loadingView.hide()
                    self.transition(self, .pop)
                }
                
                // TODO: - 수정 전 값과 같으면 로티 X
            }
        }
    }
}
