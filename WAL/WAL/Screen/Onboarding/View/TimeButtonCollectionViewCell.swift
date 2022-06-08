//
//  TimeButtonCollectionViewCell.swift
//  WAL
//
//  Created by heerucan on 2022/05/07.
//

import UIKit

import WALKit

protocol ChangeCompleteButtonDelegate: AlarmCollectionViewCell {
    func touchupCompleteButton(isDisabled: Bool)
}

class TimeButtonCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Property
    
    public override var isSelected: Bool {
        didSet {
            configUI()
            print("----------- 날짜 버튼 선택됐나?", isSelected)
        }
    }
    
    // ✅ 셀의 인덱스를 알기 위함
    var index: Int?

    // ✅ isSelected 변수를 오버라이드하지 않고 새롭게 변수를 둠
    var selectedState: Bool = false {
        didSet {
            configUI()
        }
    }
    
    private let timeData = TimeData()
    
    weak var completeButtonDelegate: ChangeCompleteButtonDelegate?
    
    // ✅ 가장 바깥 부분에 버튼 올림
    public lazy var timeButton = UIButton().then {
        $0.makeRound(radius: 10)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray400.cgColor
        $0.backgroundColor = .clear
        $0.addSubviews([timeImageView, titleLabel])
        $0.addTarget(self, action: #selector(touchupTimeButton), for: .touchUpInside)
    }
    
    public let timeImageView = UIImageView()
    
    public let titleLabel = UILabel().then {
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
        timeButton.layer.borderColor = selectedState ?
        UIColor.orange100.cgColor : UIColor.gray400.cgColor
    }
    
    private func setupLayout() {
        contentView.addSubview(timeButton)
        
        timeButton.snp.makeConstraints { make in
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
    
    // MARK: - @objc
    
    // ✅ 버튼 클릭했을 때 == 셀 클릭했을 때
    @objc func touchupTimeButton() {
        guard let index = index else { return }
        selectedState.toggle()
        print("\(index)번째 셀 \(selectedState)")
        if selectedState == false {
            completeButtonDelegate?.touchupCompleteButton(isDisabled: true)
        } 
    }
    
    // MARK: - setupData
    
    public func setupData(index: Int) {
        titleLabel.text = timeData.getTimeLabel(index: index)
        timeImageView.image = timeData.getTimeImage(index: index)
    }
}
