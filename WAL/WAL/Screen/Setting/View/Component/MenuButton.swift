//
//  MenuButton.swift
//  WAL
//
//  Created by heerucan on 2022/06/28.
//

import UIKit

import WALKit

class MenuButton: UIButton {
    
    // MARK: - Property
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .gray600 : .white
        }
    }
    
    private let settingData = SettingData()
           
    private let lineView = UIView().then {
        $0.backgroundColor = .gray600
    }
    
    private let menuLabel = UILabel().then {
        $0.font = WALFont.body6.font
        $0.textColor = .black100
    }
    
    // MARK: - Initialize
    
    init(_ index: Int) {
        super.init(frame: .zero)
        configUI()
        setupLayout()
        menuLabel.text = settingData.getMenuLabel(settingData.mypageRowData, index)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - InitUI
    
    private func configUI() {
        backgroundColor = .white100
    }
    
    private func setupLayout() {
       addSubviews([lineView,
                    menuLabel])
        
        lineView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        menuLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }
    }
}
