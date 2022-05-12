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
    
    private lazy var secondView = AlarmView(.secondMenu)
    
    private let backView = UIView().then {
        $0.backgroundColor = .white100
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "왈소리 받는 시간"
        $0.font = WALFont.body6.font
        $0.textColor = .black100
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupLayout()
    }
    
    // MARK: - InitUI
    
    private func configUI() {
        view.backgroundColor = .white100
    }
    
    private func setupLayout() {
        view.addSubviews([navigationBar, firstView, secondView, backView, titleLabel])
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(47)
            make.leading.trailing.equalToSuperview()
        }
        
        firstView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        secondView.snp.makeConstraints { make in
            make.top.equalTo(firstView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        backView.snp.makeConstraints { make in
            make.top.equalTo(secondView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backView.snp.bottom).offset(23)
            make.leading.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - Custom Method

    
    // MARK: - @objc
    
    @objc func touchupBackButton() {
        
    }

}
