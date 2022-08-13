//
//  CategoryButton.swift
//  WAL
//
//  Created by heerucan on 2022/06/27.
//

import UIKit

import WALKit

class CategoryButton: UIButton {
    
    // MARK: - Property
    
    private let cardData = CardData()
            
    private let wallbbongImageView = UIImageView()
        
    private let categoryLabel = UILabel().then {
        $0.font = WALFont.body6.font
        $0.textColor = .black100
        $0.textAlignment = .center
    }
    
    // MARK: - Initialize
    
    init(_ index: Int) {
        super.init(frame: .zero)
        configUI()
        setupLayout()
        categoryLabel.text = cardData.getCardLabel(index: index)
        wallbbongImageView.image = cardData.getWallbbongImage(index: index)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - InitUI
    
    private func configUI() {
        makeRound(radius: 10)
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray400.cgColor
    }
    
    private func setupLayout() {
       addSubviews([wallbbongImageView, categoryLabel])
        
        wallbbongImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(26)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(77)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(wallbbongImageView.snp.bottom).offset(7)
            make.bottom.equalToSuperview().inset(28)
            make.centerX.equalToSuperview()
        }
    }
}
