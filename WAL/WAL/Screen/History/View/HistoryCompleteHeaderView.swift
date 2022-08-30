//
//  HistoryCompleteHeaderView.swift
//  WAL
//
//  Created by 소연 on 2022/05/03.
//

import UIKit

import Then

import WALKit

protocol HistoryCompleteHeaderViewDelegate: HistoryViewController {
    func touchUpInformationButton()
}

final class HistoryCompleteHeaderView: UIView {
    
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
    
    var countLabel = UILabel().then {
        $0.textColor = .black
        $0.font = WALFont.body5.font
    }
    
    private var divideView = UIView().then {
        $0.backgroundColor = .gray600
    }
    
    private lazy var informationButton = UIButton().then {
        $0.setTitle("", for: .normal)
        $0.setImage(WALIcon.btnInfo.image, for: .normal)
        $0.addTarget(self, action: #selector(touchUpInformationButton), for: .touchUpInside)
    }
    
    private var bubbleImageView = UIImageView().then {
        $0.image = WALIcon.icnBubble.image
        $0.isHidden = true
    }
    
    private var informationTitleLabel = UILabel().then {
        $0.text = "박스를 옆으로 밀어 재전송 할 수 있어요"
        $0.textColor = .white
        $0.font = WALFont.body9.font
        $0.addLetterSpacing()
    }
    
    weak var delegate: HistoryCompleteHeaderViewDelegate?
    
    var informationIsHidden: Bool = false {
        didSet {
            bubbleImageView.isHidden = informationIsHidden ? false : true
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
        addSubviews([titleLabel, countLabel, bubbleImageView, divideView, informationButton])
        bubbleImageView.addSubview(informationTitleLabel)
        
        divideView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(10)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(divideView.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(20)
        }
        
        countLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(4)
        }
        
        informationButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.leading.equalTo(countLabel.snp.trailing)
            $0.width.height.equalTo(30)
        }
        
        bubbleImageView.snp.makeConstraints {
            $0.centerY.equalTo(informationButton.snp.centerY)
            $0.leading.equalTo(informationButton.snp.trailing)
            $0.width.equalTo(217)
            $0.height.equalTo(26)
        }
        
        informationTitleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(5)
            $0.leading.equalToSuperview().inset(15)
        }
    }
    
    // MARK: - @objc
    
    @objc func touchUpInformationButton() {
        delegate?.touchUpInformationButton()
    }
}
