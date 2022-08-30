//
//  HistoryHeaderView.swift
//  WAL
//
//  Created by 소연 on 2022/05/03.
//

import UIKit

import Then

import WALKit

final class HistoryReserveHeaderView: UIView {
    
    // MARK: - Properties
    
    private var titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    var title: String = "" {
        didSet {
            titleLabel.text = "\(title)"
        }
    }
    
    var countLabel = UILabel().then {
        $0.text = "234"
        $0.textColor = .black
        $0.font = WALFont.body5.font
    }
    
    // MARK: - Initializer
    
    init() {
        super.init(frame: .zero)
        configUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Init UI
    
    private func configUI() {
        backgroundColor = .clear
    }
    
    private func setupLayout() {
        addSubviews([titleLabel, countLabel])
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        countLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(4)
        }
    }
}
