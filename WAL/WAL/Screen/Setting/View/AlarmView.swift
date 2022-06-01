//
//  AlarmView.swift
//  WAL
//
//  Created by heerucan on 2022/05/08.
//

import UIKit

import WALKit

class AlarmView: UIView {
    
    // MARK: - Enum
    
    enum Alarm {
        case firstMenu
        
        var title: String {
            switch self {
            case .firstMenu:
                return "푸시 알림"
            }
        }
        
        var subtitle: String {
            switch self {
            case .firstMenu:
                return "왈소리 도착 시 알림을 받을 수 있어요"
            }
        }
        
        var toggle: Bool {
            switch self {
            case .firstMenu:
                return true
            }
        }
    }

    // MARK: - Properties
    
    public var type: Alarm = .firstMenu
    
    private let menuLabel = UILabel().then {
        $0.font = WALFont.body6.font
        $0.textColor = .black100
    }
    
    private let subMenuLabel = UILabel().then {
        $0.font = WALFont.body9.font
        $0.textColor = .gray100
    }
    
    public let toggleSwitch = UISwitch().then {
        $0.onTintColor = .mint100
    }
    
    private let lineView = UIView().then {
        $0.backgroundColor = .gray600
    }
    
    // MARK: - Life Cycle
    
    public init(_ type: Alarm) {
        super.init(frame: .zero)
        self.type = type
        configUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - InitUI
    
    private func configUI() {
        backgroundColor = .white
        menuLabel.text = type.title
        subMenuLabel.text = type.subtitle
        toggleSwitch.isOn = type.toggle
    }
    
    private func setupLayout() {
        snp.makeConstraints { make in
            make.height.equalTo(84)
        }
        
        addSubviews([menuLabel, subMenuLabel, toggleSwitch, lineView])
        
        menuLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
        }
        
        subMenuLabel.snp.makeConstraints { make in
            make.top.equalTo(menuLabel.snp.bottom).offset(6)
            make.leading.equalToSuperview().inset(20)
        }
        
        toggleSwitch.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(40)
            make.width.equalTo(42)
            make.height.equalTo(25)
        }
        
        lineView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
