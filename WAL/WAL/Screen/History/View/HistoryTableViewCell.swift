//
//  HistoryTableViewCell.swift
//  WAL
//
//  Created by 소연 on 2022/05/03.
//

import UIKit

import Then

import WALKit

class HistoryTableViewCell: UITableViewCell {
    static var cellIdentifier: String { return String(describing: self) }
    
    // MARK: - Properties
    
    private var backView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
    }
    
    private var lineView = UIView().then {
        $0.backgroundColor = .gray600
    }
    
    var coverView = UIView().then {
        $0.backgroundColor = .orange200
        $0.isHidden = true
    }
    
    private var coverLineView = UIView().then {
        $0.backgroundColor = .gray600
    }
    
    private var lockIconImageView = UIImageView().then {
        $0.image = WALIcon.icnLock.image
    }
    
    private var coverTitleLabel = UILabel().then {
        $0.text = "숨긴 왈소리"
        $0.textColor = .orange100
        $0.font = WALFont.body4.font
    }
    
    private var coverSubtitleLabel = UILabel().then {
        $0.text = "꾹 누르면 볼 수 있어요"
        $0.textColor = .orange100
        $0.font = WALFont.body9.font
    }
    
    var dDayView = UIView().then {
        $0.backgroundColor = .mint100.withAlphaComponent(0.11)
        $0.layer.cornerRadius = 10
    }
    
    var dDayLabel = UILabel().then {
        $0.text = "D-6"
        $0.font = WALFont.body8.font
        $0.textColor = .mint100
    }
    
    private var sendingDateLabel = UILabel().then {
        $0.text = "보내는 날짜"
        $0.textColor = .gray200
        $0.font = WALFont.body9.font
    }
    
    private var contentLabel = UILabel().then {
        $0.textColor = .black
        $0.font = WALFont.body7.font
    }
    
    var reserveAtLabel = UILabel().then {
        $0.text = "받는 날짜"
        $0.textColor = .gray200
        $0.font = WALFont.body7.font
        $0.isHidden = true
    }
    
    private lazy var historyStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    private lazy var dateStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.spacing = 7
    }
    
    var isExpanded: Bool = false {
        didSet {
            reserveAtLabel.isHidden = !isExpanded
        }
    }
    
    var isPressed: Bool = false {
        didSet {
            if !coverView.isHidden {
                coverView.isHidden = isPressed ? false : true
            }
        }
    }
    var isContentHidden: Bool = false {
        didSet {
            if isContentHidden { isUserInteractionEnabled = false }
        }
    }
    
    var postId: Int = 0
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Init UI
    
    private func configUI() {
        contentView.backgroundColor = .white
    }
    
    private func setLayout() {
        contentView.addSubviews([backView, coverView, lineView])
        historyStackView.addSubviews([dateStackView, contentLabel, reserveAtLabel])
        dateStackView.addArrangedSubviews([dDayView, sendingDateLabel])

        dDayView.addSubview(dDayLabel)
        backView.addSubviews([lineView, historyStackView])
        coverView.addSubviews([coverLineView, lockIconImageView, coverTitleLabel, coverSubtitleLabel])
        
        backView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        
        coverView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        coverLineView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        
        lockIconImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.leading.equalToSuperview().inset(137)
            $0.width.height.equalTo(22)
        }
        
        coverTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(42)
            $0.leading.equalTo(lockIconImageView.snp.trailing).offset(4)
        }
        
        coverSubtitleLabel.snp.makeConstraints {
            $0.top.equalTo(coverTitleLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
        
        historyStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(25)
            $0.leading.equalToSuperview().inset(35)
            $0.centerX.centerY.equalToSuperview()
        }
        
        dateStackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        dDayView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(22)
        }

        dDayLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(6)
            $0.centerX.centerY.equalToSuperview()
        }
        
        sendingDateLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(dateStackView.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(42).priority(250)
        }
        
        reserveAtLabel.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(7)
            $0.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Custom Method
    
    override func prepareForReuse() {
        dDayView.isHidden = false
    }
    
    func update() {
        contentLabel.numberOfLines = 0
        historyStackView.layoutIfNeeded()
    }
    
    func hideDdayView() {
        dDayView.isHidden = true
    }
    
    internal func setData(_ data: HistoryData) {
        postId = data.reservationID
        if data.showStatus == "OPEN" {
            isContentHidden = false
            coverView.isHidden = true
        } else {
            isContentHidden = true
            coverView.isHidden = false
        }
        
        let calendar = Calendar.current
        let currentDate = Date()
        var daysCount:Int = 0
  
        let sendingDate = data.sendingDate.components(separatedBy:".")
        func days(from date: Date) -> Int {
            return (calendar.dateComponents([.day], from: currentDate, to: date).day ?? 0) + 1
        }
        daysCount = days(from: sendingDate[0].toDate() ?? currentDate)
        
        dDayLabel.text = "D-\(daysCount)"
        
        sendingDateLabel.text = "\(data.detail)"
        
        contentLabel.text = data.message
        
        let details = data.reservedAt.components(separatedBy:".")
        reserveAtLabel.text = "\(details[0])"
        
        [sendingDateLabel, contentLabel, reserveAtLabel].forEach {
            $0.addLetterSpacing()
            $0.textAlignment = .left
        }
        
        contentLabel.numberOfLines = 1
        contentLabel.lineBreakMode = .byTruncatingTail
        
//        coverView.isHidden = data.hidden ?? false ? false : true
    }
}
