//
//  SettingAlarmCollectionViewCell.swift
//  WAL
//
//  Created by heerucan on 2022/05/12.
//

import UIKit

import WALKit

final class SettingAlarmCollectionViewCell: UICollectionViewCell {
        
    // MARK: - Property
    
    private var data = AlarmTimeData()
    
    override var isSelected: Bool {
        didSet {
            configUI()
        }
    }
        
    lazy var timeView = UIView().then {
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray400.cgColor
        $0.backgroundColor = .white100
        $0.addSubviews([timeImageView, titleLabel])
    }
    
    let timeImageView = UIImageView()
    
    let titleLabel = UILabel().then {
        $0.font = WALFont.body6.font
        $0.textColor = .black100
        $0.textAlignment = .center
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
        timeView.layer.borderColor = isSelected ?
        UIColor.orange100.cgColor : UIColor.gray400.cgColor
    }
    
    private func setupLayout() {
        contentView.addSubview(timeView)
        
        timeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        timeImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(14)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(timeImageView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - setupData
    
    func setupData(index: Int) {
        titleLabel.text = data.getTimeLabel(index: index)
        timeImageView.image = data.getTimeImage(index: index)
    }
}
