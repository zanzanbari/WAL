//
//  CardButton.swift
//  WAL
//
//  Created by heerucan on 2022/06/14.
//

import UIKit

import WALKit

class CardButton: UIButton {
    
    // MARK: - Property
    
    private let cardData = CardData()
            
    private let cardImageView = UIImageView()
    private let wallbbongImageView = UIImageView()
        
    private let categoryLabel = UILabel().then {
        $0.font = WALFont.body2.font
        $0.textColor = .black100
        $0.textAlignment = .center
    }
    
    private let categorySubLabel = UILabel().then {
        $0.font = WALFont.body7.font
        $0.textColor = .black100
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    // MARK: - Initialize
    
    init(_ index: Int) {
        super.init(frame: .zero)
        configUI()
        setupLayout()
        categoryLabel.text = cardData.getCardLabel(index: index)
        categorySubLabel.text = cardData.getCardSubLabel(index: index)
        wallbbongImageView.image = cardData.getWallbbongImage(index: index)
        cardImageView.image = cardData.getCardImage(index: index)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - InitUI
    
    private func configUI() {
        makeRound(radius: 10)
        layer.borderWidth = 1
        layer.borderColor = UIColor.clear.cgColor
    }
    
    private func setupLayout() {
        addSubview(cardImageView)
        cardImageView.addSubviews([wallbbongImageView, categoryLabel, categorySubLabel])
        
        cardImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        wallbbongImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(37)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(140)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(wallbbongImageView.snp.bottom).offset(17)
            make.centerX.equalToSuperview()
        }
        
        categorySubLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(14)
            make.centerX.equalToSuperview()
        }
    }
}
