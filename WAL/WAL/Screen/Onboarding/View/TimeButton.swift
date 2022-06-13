//
//  TimeButton.swift
//  WAL
//
//  Created by heerucan on 2022/05/07.
//

import UIKit

import WALKit

class TimeButton: UIButton {
    
    // MARK: - Property
            
    public let timeLabel = UILabel().then {
        $0.font = WALFont.body6.font
        $0.textColor = .black100
        $0.textAlignment = .center
    }
    
    public let timeImageView = UIImageView()
    
    // MARK: - Initialize
    
    init(_ text: String, _ image: UIImage) {
        super.init(frame: .zero)
        configUI()
        setupLayout()
        timeLabel.text = text
        timeImageView.image = image
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
        addSubviews([timeImageView, timeLabel])
        
        timeImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(14)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(44)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(timeImageView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
    }
}
