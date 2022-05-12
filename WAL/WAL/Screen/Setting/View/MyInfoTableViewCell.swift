//
//  MyInfoTableViewCell.swift
//  WAL
//
//  Created by heerucan on 2022/05/08.
//

import UIKit

import WALKit

class MyInfoTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private lazy var backView = UIView().then {
        $0.layer.cornerRadius = 14
        $0.layer.borderColor = UIColor.mint100.cgColor
        $0.layer.borderWidth = 1
        $0.addSubviews([nicknameLabel, emailLabel, infoLabel])
    }
    
    public let nicknameLabel = UILabel().then {
        $0.text = "디오니바봉짱"
        $0.font = WALFont.body1.font
        $0.textColor = .black100
    }
    
    public let emailLabel = UILabel().then {
        $0.text = "jiwonsocute@gmail.com"
        $0.font = WALFont.body9.font
        $0.textColor = .gray100
    }
    
    private let infoLabel = UILabel().then {
        $0.text = "내 정보"
        $0.font = WALFont.body7.font
        $0.textColor = .gray200
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
        contentView.addSubview(backView)
        
        backView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.leading.bottom.trailing.equalToSuperview().inset(20)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(22)
            make.leading.equalToSuperview().inset(20)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().inset(20)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(33)
            make.bottom.equalToSuperview().inset(31)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - Custom Method


}
