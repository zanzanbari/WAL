//
//  SettingTableViewCell.swift
//  WAL
//
//  Created by heerucan on 2022/05/08.
//

import UIKit

import WALKit

class SettingTableViewCell: UITableViewCell {
    
    static let identifier = Constant.settingTableViewCell

    // MARK: - Properties
    
    private let setting = SettingData()
    
    public let menuLabel = UILabel().then {
        $0.font = WALFont.body6.font
        $0.textColor = .black100
    }
    
    public let subMenuLabel = UILabel().then {
        $0.font = WALFont.body6.font
        $0.textColor = .gray200
    }
    
    private let lineView = UIView().then {
        $0.backgroundColor = .gray600
    }
        
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - InitUI
    
    private func configUI() {
        contentView.backgroundColor = .white100
    }
    
    private func setupLayout() {
        contentView.addSubviews([menuLabel, subMenuLabel, lineView])
        
        menuLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(20)
        }
        
        subMenuLabel.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview().inset(20)
        }
        
        lineView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - Custom Method

    public func setupData(index: Int) {
        menuLabel.text = setting.getMenuLabel(setting.secondRowData, index)
        subMenuLabel.text = setting.getSubMenuLabel(setting.secondRowData, index)
    }
}
