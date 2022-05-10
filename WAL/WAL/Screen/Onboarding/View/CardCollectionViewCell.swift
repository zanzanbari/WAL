//
//  CardCollectionViewCell.swift
//  WAL
//
//  Created by heerucan on 2022/05/06.
//

import UIKit

import WALKit

class CardCollectionViewCell: UICollectionViewCell {
    
//    public override var isSelected: Bool {
//        didSet {
//            configUI()
//        }
//    }
    
    // ✅ 셀의 인덱스를 알기 위함
    var index: Int?
    // ✅ isSelected 변수를 오버라이드하지 않고 새롭게 변수를 둠
    var selectedState: Bool = false {
        didSet {
            configUI()
        }
    }

    // MARK: - Property
    
    private let cardData = CardData()
    
    public lazy var cardImageView = UIImageView().then {
        $0.addSubviews([dogImageView, titleLabel, subtitleLabel])
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray400.cgColor
        $0.layer.cornerRadius = 10
    }
    
    public let dogImageView = UIImageView()
    
    public let titleLabel = UILabel().then {
        $0.font = WALFont.body2.font
        $0.textColor = .black100
        $0.textAlignment = .center
    }
    
    public let subtitleLabel = UILabel().then {
        $0.font = WALFont.body7.font
        $0.textColor = .black100
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    // ✅ 가장 바깥 부분에 버튼 올림
    lazy var button = UIButton().then {
        $0.backgroundColor = .clear
        $0.addTarget(self, action: #selector(addEvent), for: .touchUpInside)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray400.cgColor
        $0.layer.cornerRadius = 10
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
        // ✅ 버튼의 레이어 색을 변경해줌
        button.layer.borderColor = selectedState ?
        UIColor.orange100.cgColor : UIColor.gray400.cgColor
    }
    
    private func setupLayout() {
        contentView.addSubview(cardImageView)
        contentView.addSubview(button)
        
        cardImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        dogImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(37)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(140)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(dogImageView.snp.bottom).offset(17)
            make.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // ✅ 버튼 클릭했을 때 == 셀 클릭했을 때
    @objc func addEvent() {
        guard let index = index else { return }
        selectedState.toggle()
        print("\(index)번째 셀 \(selectedState)")
    }
    
    // MARK: - setupData
    
    public func setupData(index: Int) {
        titleLabel.text = cardData.getCardLabel(index: index)
        subtitleLabel.text = cardData.getCardSubLabel(index: index)
        cardImageView.image = cardData.getCardImage(index: index)
        dogImageView.image = cardData.getWallbbongImage(index: index)
    }
}
