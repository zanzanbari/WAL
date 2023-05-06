//
//  CardButton.swift
//  WAL
//
//  Created by heerucan on 2022/06/14.
//

import UIKit

import WALKit

final class CardButton: UIButton {
    
    // MARK: - Property
    
    override var isSelected: Bool {
        didSet {
            layer.borderColor = isSelected
            ? UIColor.orange100.cgColor : UIColor.gray400.cgColor
        }
    }
                
    private let cardImageView = UIImageView()
    private let wallbbongImageView = UIImageView()
        
    private let categoryLabel = UILabel().then {
        $0.font = WALFont.body2.font
        $0.textColor = .black100
        $0.textAlignment = .center
    }
    
    let categorySubLabel = UILabel().then {
        $0.font = WALFont.body7.font
        $0.textColor = .black100
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    // MARK: - Initialize
    
    init(_ type: WalCategoryType) {
        super.init(frame: .zero)
        configUI(type: type)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - InitUI
    
    private func configUI(type: WalCategoryType) {
        makeRound(radius: 10)
        layer.borderWidth = 1
        layer.borderColor = UIColor.clear.cgColor
        categoryLabel.text = type.kor
        categorySubLabel.text = type.description
        wallbbongImageView.image = type.walImage
        cardImageView.image = type.cardImage
        tag = type.categoryId
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
