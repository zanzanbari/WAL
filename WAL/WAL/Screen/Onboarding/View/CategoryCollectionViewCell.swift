//
//  CategoryCollectionViewCell.swift
//  WAL
//
//  Created by heerucan on 2022/05/02.
//

import UIKit

import Then
import WALKit

final class CategoryCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Properties
    
    weak var sendCategoryDelegate: SendCategoryDelegate?
        
    private var barWidth: CGFloat = 0
                
    private lazy var categoryButtons = [comedyButton, fussButton, comfortButton, yellButton]
    
    private let titleLabel = UILabel().then {
        $0.font = WALFont.title2.font
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    private let subtitleLabel = UILabel().then {
        $0.font = WALFont.body7.font
        $0.text = "다중선택 가능해요"
        $0.numberOfLines = 0
    }
    
    lazy var scrollView = UIScrollView().then {
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
    
    private let comedyButton = CardButton(.comedy)
    private let fussButton = CardButton(.fuss)
    private let comfortButton = CardButton(.comfort)
    private let yellButton = CardButton(.yell)
    
    lazy var slideBackView = UIView().then {
        $0.backgroundColor = .gray500
        $0.makeRound(radius: 1)
        $0.addSubview(slideBar)
    }
    
    private let slideBar = UIView().then {
        $0.backgroundColor = .orange100
        $0.makeRound(radius: 1)
    }
    
    lazy var nextButton = WALPlainButton().then {
        $0.title = "다음"
        $0.isDisabled = true
    }
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        setupLayout()
    }

    // MARK: - InitUI
    
    private func configUI() {
        contentView.backgroundColor = .white100
        barWidth = (contentView.frame.width-61*2)/4
        categoryButtons.forEach {
            $0.categorySubLabel.addLetterSpacing()
            $0.addTarget(self, action: #selector(touchupButton(sender:)), for: .touchUpInside)
        }
    }
    
    private func setupLayout() {
        contentView.addSubviews([titleLabel, subtitleLabel, slideBackView, nextButton])
        contentView.addSubview(scrollView)
        scrollView.addSubview(cardButtonStackView)
        cardButtonStackView.addArrangedSubviews(categoryButtons)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(UIScreen.main.hasNotch ? 16 : 23)
            make.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(9)
            make.centerX.equalToSuperview()
        }
        
        categoryButtons.forEach {
            $0.snp.makeConstraints { make in
                make.width.equalTo(contentView.frame.width-61*2)
                make.height.equalTo(
                    UIScreen.main.hasNotch ?
                    (322*(contentView.frame.width-61*2)) / 253 : (295*(contentView.frame.width-61*2)) / 248)
            }
        }
        
        cardButtonStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(61)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(UIScreen.main.hasNotch ? 50 : 34)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(
                UIScreen.main.hasNotch ?
                (322*(contentView.frame.width-61*2)) / 253 : (295*(contentView.frame.width-61*2)) / 248)
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
            make.bottom.equalToSuperview().inset(UIScreen.main.hasNotch ? 50 : 26)
        }
    }
    
    // MARK: - Custom Method
    
    override func setupNotificationCenter() {
        super.setupNotificationCenter()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(changeNickname(_:)),
            name: .changeNickname,
            object: nil)
    }
    
    func touchupNextButton(isDisabled: Bool) {
        nextButton.isDisabled = isDisabled
    }
    
    // MARK: - @objc
    
    @objc func changeNickname(_ notification: Notification) {
        guard let nickname = notification.userInfo?["nickname"] as? String else { return print("여기로빠지냐?")}
        titleLabel.text = nickname + "님이 받고싶은\n왈소리 유형은?"
        titleLabel.addLetterSpacing()
    }
    
    @objc func touchupButton(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        let isSelected = categoryButtons.allSatisfy { $0.layer.borderColor == UIColor.clear.cgColor }
        nextButton.isDisabled = isSelected
        
        let selectedButtons = categoryButtons.filter { $0.isSelected }
        let data = selectedButtons.map { WalCategoryType.allCases[$0.tag].rawValue }
        
        sendCategoryDelegate?.sendCategory(data: data)
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
