//
//  ZanzanView.swift
//  WAL
//
//  Created by heerucan on 2022/08/05.
//

import UIKit

import WALKit
import Then

class ZanzanView: UIView {
    
    var image: UIImage = WALIcon.icnDesigner.image {
        didSet {
            imageView.image = image
        }
    }
    
    var part: String = "Design" {
        didSet {
            partLabel.text = part
        }
    }
    
    var firstName: String = "김준희" {
        didSet {
            firstNameLabel.text = firstName
        }
    }
    
    var secondName: String = "이지원" {
        didSet {
            secondNameLabel.text = secondName
        }
    }
    
    var imageView = UIImageView()
    var partLabel = UILabel()
    var firstNameLabel = UILabel()
    var secondNameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - InitUI
    
    private func configNameLabel(label: UILabel) {
        label.textColor = .black100
        label.font = WALFont.body7.font
    }
    
    private func configUI() {
        imageView.image = WALIcon.icnDesigner.image
        
        partLabel.textColor = .orange100
        partLabel.font = WALFont.body9.font
        
        configNameLabel(label: firstNameLabel)
        configNameLabel(label: secondNameLabel)
    }
    
    private func setupLayout() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.height.equalTo(64)
        }
        
        partLabel.snp.makeConstraints { make in
            make.top.equalTo(9)
            make.leading.equalTo(imageView.snp.trailing).offset(18)
        }
        
        firstNameLabel.snp.makeConstraints { make in
            make.top.equalTo(partLabel.snp.bottom).offset(1)
            make.leading.equalTo(imageView.snp.trailing).offset(18)
        }
        
        secondNameLabel.snp.makeConstraints { make in
            make.top.equalTo(partLabel.snp.bottom).offset(1)
            make.leading.equalTo(firstNameLabel.snp.trailing).offset(10)
        }
    }
}
