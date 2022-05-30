//
//  HistoryTableViewCell.swift
//  WAL
//
//  Created by 소연 on 2022/05/03.
//

import UIKit

import SnapKit
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
    
    private var coverView = UIView().then {
        $0.backgroundColor = .orange200
        $0.isHidden = true
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
    
    private var reserveLabel = UILabel().then {
        $0.text = "보내는 날짜"
        $0.font = WALFont.body8.font
    }
    
    private var contentLabel = UILabel().then {
        $0.textColor = .black
        $0.font = WALFont.body7.font
        $0.numberOfLines = 2
    }
    
    private var recieveLabel = UILabel().then {
        $0.text = "받는 날짜"
        $0.textColor = .gray200
        $0.font = WALFont.body7.font
        $0.isHidden = true
    }
    
    var dateLabelColor: UIColor = .gray200 {
        didSet {
            reserveLabel.textColor = dateLabelColor
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
        backView.addSubviews([lineView, reserveLabel, contentLabel, recieveLabel])
        coverView.addSubviews([lockIconImageView, coverTitleLabel, coverSubtitleLabel])
        
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
        
        reserveLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(26)
            $0.leading.equalToSuperview().inset(35)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(reserveLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(35)
            $0.bottom.equalToSuperview().inset(25)
        }
        
        recieveLabel.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(10)
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
                $0.top.equalTo(reserveLabel.snp.bottom).offset(15)
                $0.leading.trailing.equalToSuperview().inset(35)
                $0.bottom.equalToSuperview().inset(51)
            }
            contentLabel.numberOfLines = 0
            
            recieveLabel.isHidden = false
        } else {
            contentLabel.numberOfLines = 2
            recieveLabel.isHidden = true
        }
    }
    
    internal func setData(_ data: HistoryDataModel) {
        isContentHidden = data.hidden
        
        reserveLabel.text = "\(data.reserveDate)"
        reserveLabel.addLetterSpacing()
        
        contentLabel.text = data.content
        contentLabel.addLetterSpacing()
        
        recieveLabel.text = "\(data.recieveDate)"
        recieveLabel.addLetterSpacing()
        
        coverView.isHidden = data.hidden ? false : true
    }
}
