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
        
    private var barWidth: CGFloat = 0
    
    private let titleLabel = UILabel().then {
        $0.font = WALFont.title2.font
        $0.text = "디오니방구님이 받고싶은 \n 왈소리 유형은?"
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    private let subtitleLabel = UILabel().then {
        $0.font = WALFont.body7.font
        $0.text = "다중선택 가능해요"
        $0.numberOfLines = 0
    }
    
    public lazy var scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.delegate = self
        $0.isPagingEnabled = false
        $0.decelerationRate = .fast
    }
    
    private lazy var cardButtonStackView = UIStackView().then {
        $0.spacing = 18
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .equalSpacing
    }
    
    public let funButton = CardButton(0)
    private let loveButtoon = CardButton(1)
    private let cheerButton = CardButton(2)
    private let angryButton = CardButton(3)
    
    public lazy var slideBackView = UIView().then {
        $0.backgroundColor = .gray500
        $0.makeRound(radius: 1)
        $0.addSubview(slideBar)
    }
    
    private let slideBar = UIView().then {
        $0.backgroundColor = .orange100
        $0.makeRound(radius: 1)
    }
    
    public lazy var nextButton = WALPlainButton().then {
        $0.title = "다음"
        $0.isDisabled = true
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
        contentView.backgroundColor = .white100
        barWidth = (contentView.frame.width-61*2)/4
        print(barWidth)
        [funButton, loveButtoon, cheerButton, angryButton].forEach {
            $0.addTarget(self, action: #selector(touchupButton(sender:)), for: .touchUpInside)
        }
    }
    
    private func setupLayout() {
        contentView.addSubviews([titleLabel,
                                 subtitleLabel,
                                 slideBackView,
                                 nextButton])
        
        contentView.addSubview(scrollView)
        
        scrollView.addSubview(cardButtonStackView)
        cardButtonStackView.addArrangedSubviews([
            funButton, loveButtoon, cheerButton, angryButton])
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(9)
            make.centerX.equalToSuperview()
        }
        
        [funButton, loveButtoon, cheerButton, angryButton].forEach {
            $0.snp.makeConstraints { make in
                make.width.equalTo(contentView.frame.width-61*2)
                make.height.equalTo((322*(contentView.frame.width-61*2)) / 253)
        } }
        
        cardButtonStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(61)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(50)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo((322*(contentView.frame.width-61*2)) / 253)
        }
        
        slideBackView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(61)
            make.height.equalTo(2)
        }
        
        slideBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(0)
            make.width.equalTo(barWidth)
            make.height.equalTo(2)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(50)
        }
    }
    
    func touchupNextButton(isDisabled: Bool) {
        nextButton.isDisabled = isDisabled
    }
    
    @objc func touchupButton(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.layer.borderColor = sender.isSelected ? UIColor.orange100.cgColor : UIColor.clear.cgColor
        
        nextButton.isDisabled =
        funButton.layer.borderColor == UIColor.clear.cgColor &&
        loveButtoon.layer.borderColor == UIColor.clear.cgColor &&
        cheerButton.layer.borderColor == UIColor.clear.cgColor &&
        angryButton.layer.borderColor == UIColor.clear.cgColor ? true : false
    }
}

// MARK: - UIScrollDelegate

extension CategoryCollectionViewCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetX = scrollView.contentOffset.x
        let cellIndex = round(contentOffsetX/(slideBackView.frame.width)*100)/100
                
        if round(cellIndex*100)/100 <= 3.0 {
            slideBar.snp.updateConstraints { make in
                make.leading.equalToSuperview().inset(round(cellIndex*barWidth*10)/10)
            }
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cardWidthSpacing = contentView.frame.width-61*2 + 18
        let estimatedIndex = scrollView.contentOffset.x / cardWidthSpacing
        let index: Int
        
        if velocity.x > 0 {
            index = Int(ceil(estimatedIndex))
        } else if velocity.x < 0 {
            index = Int(floor(estimatedIndex))
        } else {
            index = Int(round(estimatedIndex))
        }
        targetContentOffset.pointee = CGPoint(x: CGFloat(index) * cardWidthSpacing, y: 0)
    }
}
