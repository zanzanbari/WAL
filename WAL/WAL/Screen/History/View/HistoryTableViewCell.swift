//
//  HistoryTableViewCell.swift
//  WAL
//
//  Created by 소연 on 2022/05/03.
//

import UIKit

import Then

import WALKit

class ExpandTableViewCellContent {
    var isExpanded: Bool
    
    init() {
        self.isExpanded = false
    }
}

class HistoryTableViewCell: UITableViewCell {
    static var cellIdentifier: String { return String(describing: self) }
    
    // MARK: - Properties
    
    private var backView = UIView().then {
        $0.backgroundColor = .white
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
    
    private var sendingDateLabel = UILabel().then {
        $0.text = "보내는 날짜"
        $0.font = WALFont.body8.font
    }
    
    private var contentLabel = UILabel().then {
        $0.textColor = .black
        $0.font = WALFont.body7.font
        $0.numberOfLines = 2
    }
    
    private var reserveAtLabel = UILabel().then {
        $0.text = "받는 날짜"
        $0.textColor = .gray200
        $0.font = WALFont.body7.font
        $0.isHidden = true
    }
    
    var sendingDateLabelColor: UIColor = .gray200 {
        didSet {
            sendingDateLabel.textColor = sendingDateLabelColor
        }
    }
    
    var isExpanded: Bool = false
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
        backView.addSubviews([lineView, sendingDateLabel, contentLabel, reserveAtLabel])
        coverView.addSubviews([coverLineView, lockIconImageView, coverTitleLabel, coverSubtitleLabel])
        
        lineView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        
        backView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
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
            $0.leading.equalToSuperview().inset(139)
            $0.width.height.equalTo(22)
        }
        
        coverTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(42)
            $0.leading.equalTo(lockIconImageView.snp.trailing).offset(4)
        }
        
        coverSubtitleLabel.snp.makeConstraints {
            $0.top.equalTo(coverTitleLabel.snp.bottom).offset(3)
            $0.centerX.equalToSuperview()
        }
        
        sendingDateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(26)
            $0.leading.equalToSuperview().inset(35)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(sendingDateLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(35)
            $0.bottom.equalToSuperview().inset(25)
        }
        
        reserveAtLabel.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(7)
            $0.trailing.equalToSuperview().inset(35)
        }
    }
    
    // MARK: - Custom Method
    
    internal func initCell(isTapped :ExpandTableViewCellContent) {
        isExpanded = isTapped.isExpanded
        
        if isExpanded {
            backView.snp.updateConstraints {
                $0.top.bottom.leading.trailing.equalToSuperview()
            }

            contentLabel.snp.updateConstraints {
                $0.bottom.equalToSuperview().inset(51)
            }
            contentLabel.numberOfLines = 0
            
            reserveAtLabel.isHidden = false
        } else {
            contentLabel.numberOfLines = 2
            
            if contentLabel.countCurrentLines() == 1 {
                contentLabel.snp.updateConstraints {
                    $0.bottom.equalToSuperview().inset(72)
                }
            } else {
                contentLabel.snp.updateConstraints {
                    $0.bottom.equalToSuperview().inset(25)
                }
            }
            
            reserveAtLabel.isHidden = true
        }
    }
    
    internal func setData(_ data: HistoryData) {
        postId = data.postID
        
        isContentHidden = data.hidden ?? false
        
        sendingDateLabel.text = "\(data.sendingDate)"
        sendingDateLabel.addLetterSpacing()
        
        contentLabel.text = data.content
        contentLabel.addLetterSpacing()
        if contentLabel.countCurrentLines() == 1 {
            contentLabel.snp.updateConstraints {
                $0.bottom.equalToSuperview().inset(46)
            }
        } else {
            contentLabel.snp.updateConstraints {
                $0.bottom.equalToSuperview().inset(25)
            }
        }
        
        reserveAtLabel.text = "\(data.reserveAt)"
        reserveAtLabel.addLetterSpacing()
        
        coverView.isHidden = data.hidden ?? false ? false : true
    }
}
