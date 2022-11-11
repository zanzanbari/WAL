//
//  MyInfoTableViewCell.swift
//  WAL
//
//  Created by heerucan on 2022/05/08.
//

import UIKit

import WALKit

class MyInfoTableViewCell: BaseTableViewCell {
        
    // MARK: - Properties
    
    private lazy var backView = UIView().then {
        $0.layer.cornerRadius = 14
        $0.layer.borderColor = UIColor.mint100.cgColor
        $0.layer.borderWidth = 1
        $0.addSubviews([nicknameLabel, socialTypeLabel, infoLabel])
    }
    
    let nicknameLabel = UILabel().then {
        $0.font = WALFont.body1.font
        $0.textColor = .black100
    }
    
    let socialTypeLabel = UILabel().then {
        $0.font = WALFont.body9.font
        $0.textColor = .gray100
        if UserDefaultsHelper.standard.social == "kakao" {
            $0.text = "카카오 계정으로 로그인"
        } else if UserDefaultsHelper.standard.social == "apple" {
            $0.text = "애플 계정으로 로그인"
        }
    }
    
    private let infoLabel = UILabel().then {
        $0.text = "내 정보"
        $0.font = WALFont.body7.font
        $0.textColor = .gray200
    }
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    // MARK: - InitUI
    
    private func setupLayout() {
        contentView.addSubview(backView)
        
        backView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.leading.bottom.trailing.equalToSuperview().inset(20)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(22)
            make.leading.equalToSuperview().inset(20)
        }
        
        socialTypeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(19)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.bottom.equalToSuperview().inset(32)
            make.trailing.equalToSuperview().inset(20)
        }
    }
}
