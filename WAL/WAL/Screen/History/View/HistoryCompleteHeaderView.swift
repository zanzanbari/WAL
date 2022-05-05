//
//  HistoryCompleteHeaderView.swift
//  WAL
//
//  Created by 소연 on 2022/05/03.
//

import UIKit

import SnapKit
import Then

import WALKit

final class HistoryCompleteHeaderView: UIView {
    
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
    
    private var divideView = UIView().then {
        $0.backgroundColor = .gray600
    }
    
    private var informationButton = UIButton().then {
        $0.setTitle("", for: .normal)
        $0.backgroundColor = .orange100
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
        addSubviews([titleLabel, divideView, informationButton])
        
        divideView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(10)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(divideView.snp.bottom).offset(27)
            $0.leading.equalToSuperview().inset(20)
        }
        
        informationButton.snp.makeConstraints {
            $0.top.equalTo(divideView.snp.bottom).offset(21)
            $0.leading.equalToSuperview().inset(45)
            $0.width.height.equalTo(30)
        }
    }
}
