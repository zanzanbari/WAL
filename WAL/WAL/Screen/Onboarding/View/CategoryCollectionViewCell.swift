//
//  CategoryCollectionViewCell.swift
//  WAL
//
//  Created by heerucan on 2022/05/02.
//

import UIKit

import Then
import WALKit

class CategoryCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Properties
    
    public let nextButton = WALPlainButton().then {
        $0.title = "다음"
        $0.isDisabled = false
    }
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - InitUI
    
    private func configUI() {
        contentView.backgroundColor = .yellow
    }
    
    private func setupLayout() {
        contentView.addSubviews([nextButton])
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(50)
        }
        
    }
    
    // MARK: - Custom Method
    
}
