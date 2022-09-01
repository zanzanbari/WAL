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
    
    // MARK: - Properties
    
    private var setting = SettingData()

    let checkButton = UIButton()
    
    let menuLabel = UILabel().then {
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
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        
        menuLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(checkButton.snp.trailing)
        }
    }
    
    // MARK: - Custom Method

    func setupData(index: Int) {
        menuLabel.text = setting.getResignMenuLabel(setting.resignRowData, index)
    }
}
