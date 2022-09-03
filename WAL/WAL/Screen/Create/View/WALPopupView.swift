//
//  WALPopupView.swift
//  WAL
//
//  Created by 배은서 on 2022/07/08.
//

import UIKit

import Then
import WALKit

class WALPopupView: UIView {

    // MARK: - Properties
    
    public var titleLabel = UILabel().then {
        $0.font = WALFont.title1.font
        $0.textColor = .black100
    }
    
    public var subTitleLabel = UILabel().then {
        $0.font = WALFont.body7.font
        $0.textColor = .gray100
    }
    
    private let horizontalLineView = UIView()
    private let verticalLineView = UIView()
    
    public var leftButton = UIButton().then {
        $0.setTitleColor(.black100, for: .normal)
        $0.layer.maskedCorners = .layerMinXMaxYCorner
    }
    
    public var rightButton = UIButton().then {
        $0.layer.maskedCorners = .layerMaxXMaxYCorner
    }
    
    public var leftText: String = "" {
        didSet {
            leftButton.setTitle(leftText, for: .normal)
        }
    }
    
    public var rightText: String = "" {
        didSet {
            rightButton.setTitle(rightText, for: .normal)
        }
    }
    
    //MARK: - Initializer
    
    public init(title: String, subTitle: String, rightButtonColor: UIColor) {
        super.init(frame: .zero)
        titleLabel.text = title
        subTitleLabel.text = subTitle
        rightButton.setTitleColor(rightButtonColor, for: .normal)
        
        configUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - InitUI
    
    private func configUI() {
        backgroundColor = .white100
        makeRound(radius: 15)
        
        [horizontalLineView, verticalLineView].forEach {
            $0.backgroundColor = .gray500
        }
        
        [leftButton, rightButton].forEach {
            $0.titleLabel?.font = WALFont.body4.font
        }
    }
    
    private func setupLayout() {
        addSubviews([titleLabel,
                     subTitleLabel,
                     horizontalLineView,
                     verticalLineView,
                     leftButton,
                     rightButton])
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(26)
            $0.leading.trailing.equalToSuperview().inset(27)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        horizontalLineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
        }
        
        verticalLineView.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.top.equalTo(horizontalLineView.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        leftButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(verticalLineView.snp.leading)
            $0.centerY.equalTo(verticalLineView)
        }
        
        rightButton.snp.makeConstraints {
            $0.leading.equalTo(verticalLineView.snp.trailing)
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(verticalLineView)
        }
    }
}
