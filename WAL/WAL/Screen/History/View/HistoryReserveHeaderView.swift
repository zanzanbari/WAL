//
//  HistoryHeaderView.swift
//  WAL
//
//  Created by 소연 on 2022/05/03.
//

import UIKit

import SnapKit
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
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(21)
            $0.leading.equalToSuperview().inset(20)
        }
    }
}
