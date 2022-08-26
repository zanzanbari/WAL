//
//  ResignHeaderView.swift
//  WAL
//
//  Created by heerucan on 2022/06/27.
//

import UIKit

import Then
import WALKit

class ResignHeaderView: UIView {

    // MARK: - Life Cycle
    
    private let cryingImageView = UIImageView().then {
        $0.image = WALIcon.icnCrying.image
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "왈뿡이가 이렇게 귀여운데\n탈퇴하실 거예요?"
        $0.font = WALFont.title05.font
        $0.textColor = .black100
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    private let subtitleLabel = UILabel().then {
        $0.text = Constant.Placeholder.resignText
        $0.font = WALFont.body9.font
        $0.textColor = .black100
        $0.numberOfLines = 0
    }
    
    private let menuTitleLabel = UILabel().then {
        $0.text = "탈퇴 이유를 알려주세요"
        $0.font = WALFont.body4.font
        $0.textColor = .black100
    }
    
    init() {
        super.init(frame: .zero)
        configUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - InitUI
    
    private func configUI() {
        backgroundColor = .white
        titleLabel.addLetterSpacing()
        subtitleLabel.addLetterSpacing(kernValue: -0.4, paragraphValue: 8.0)
        subtitleLabel.textAlignment = .left
    }
    
    private func setupLayout() {
        addSubviews([cryingImageView, titleLabel, subtitleLabel, menuTitleLabel])
        
        cryingImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(35)
            make.centerX.equalToSuperview()
            make.width.equalTo(142)
            make.height.equalTo(127)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(cryingImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        menuTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(34)
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(12)
        }
    }
}
