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
    
    // MARK: - Enum
    
    enum PartType {
        case iOS
        case etc
    }
    
    // MARK: - Properties
    
    var partType: PartType? {
        didSet {
            setupLayout(partType)
        }
    }
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    var part: String? {
        didSet {
            partLabel.text = part
        }
    }
    
    var firstName: String? {
        didSet {
            firstNameLabel.text = firstName
        }
    }
    
    var secondName: String? {
        didSet {
            secondNameLabel.text = secondName
        }
    }
    
    var thirdName: String? {
        didSet {
            thirdNameLabel.text = thirdName
        }
    }
    
    var fourthName: String? {
        didSet {
            fourthNameLabel.text = fourthName
        }
    }
    
    private var imageView = UIImageView()
    private var partLabel = UILabel()
    private var firstNameLabel = UILabel()
    private var secondNameLabel = UILabel()
    private var thirdNameLabel = UILabel()
    private var fourthNameLabel = UILabel()

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - InitUI
    
    private func configNameLabel(label: [UILabel]) {
        label.forEach { $0.textColor = .black100 }
        label.forEach { $0.font = WALFont.body7.font }
    }
    
    private func configUI() {
        imageView.image = WALIcon.icnDesigner.image
        partLabel.textColor = .orange100
        partLabel.font = WALFont.body9.font
        configNameLabel(label: [firstNameLabel,
                                secondNameLabel,
                                thirdNameLabel,
                                fourthNameLabel])
    }
    
    private func setupLayout(_ type: PartType?) {
        addSubviews([imageView,
                     partLabel,
                     firstNameLabel,
                     secondNameLabel])
        
        imageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.height.equalTo(64)
        }
        
        partLabel.snp.makeConstraints { make in
            make.top.equalTo(type == .iOS ? 1 : 11)
            make.leading.equalTo(imageView.snp.trailing).offset(29)
        }
        
        firstNameLabel.snp.makeConstraints { make in
            make.top.equalTo(partLabel.snp.bottom).offset(6)
            make.leading.equalTo(imageView.snp.trailing).offset(29)
        }
        
        secondNameLabel.snp.makeConstraints { make in
            make.top.equalTo(partLabel.snp.bottom).offset(6)
            make.leading.equalTo(firstNameLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview()
        }
        
        if type == .iOS {
            addSubviews([thirdNameLabel, fourthNameLabel])
            thirdNameLabel.snp.makeConstraints { make in
                make.top.equalTo(firstNameLabel.snp.bottom).offset(10)
                make.leading.equalTo(firstNameLabel.snp.leading)
            }
            
            fourthNameLabel.snp.makeConstraints { make in
                make.top.equalTo(thirdNameLabel.snp.top)
                make.leading.equalTo(secondNameLabel.snp.leading)
            }
        }
    }
}
