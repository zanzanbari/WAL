//
//  ResignTableViewCell.swift
//  WAL
//
//  Created by heerucan on 2022/06/27.
//

import UIKit

import Then
import WALKit

class ResignTableViewCell: UITableViewCell {
    
    static let identifier = Constant.resignTableViewCell

    // MARK: - Properties
    
    private let setting = SettingData()
    
    public let checkButton = UIButton().then {
        $0.setImage(WALIcon.icnSelectInactive.image, for: .normal)
        $0.setImage(WALIcon.icnSelectActive.image, for: .highlighted)
    }
    
    public let menuLabel = UILabel().then {
        $0.font = WALFont.body8.font
        $0.textColor = .black100
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
        contentView.addSubviews([lineView, checkButton, menuLabel])
        
        lineView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview()
        }
        
        checkButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.leading.equalToSuperview().inset(19)
        }
        
        menuLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(checkButton.snp.trailing).offset(11)
        }
    }
    
    // MARK: - Custom Method

    public func setupData(index: Int) {
        menuLabel.text = setting.getMenuLabel(setting.resignRowData, index)
    }
}
