//
//  MainTitleView.swift
//  WAL
//
//  Created by 소연 on 2022/12/22.
//

import UIKit

import WALKit

final class MainTitleView: UIView {
    
    // MARK: - Property
    
    var subTitle: String = "" {
        didSet {
            subTitleLabel.text = subTitle
            subTitleLabel.addLetterSpacing()
            subTitleLabel.textAlignment = .left
        }
    }
    
    // MARK: - UI Property
    
    private var titleLabel = UILabel().then {
        $0.text = "오늘의 왈소리"
        $0.textColor = .black100
        $0.font = WALFont.title0.font
    }
    
    private var subTitleLabel = UILabel().then {
        $0.textColor = .black100
        $0.font = WALFont.body3.font
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
        backgroundColor = .white100
    }
    
    private func setupLayout() {
        addSubviews([titleLabel, subTitleLabel])
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}
