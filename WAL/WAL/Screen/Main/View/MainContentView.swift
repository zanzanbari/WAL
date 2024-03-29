//
//  MainContentView.swift
//  WAL
//
//  Created by 소연 on 2022/06/16.
//

import UIKit

import WALKit

enum NumberOfContentLabel: Int {
    case one = 1
    case two
    case three
    case four
    case five
    
    var topConstraints: CGFloat {
        switch self {
        case .one:
            return 74
        case .two:
            return 60
        case .three:
            return 46
        case .four:
            return 32
        case .five:
            return 18
        }
    }
}

final class MainContentView: UIView {
    
    // MARK: - UI Property
    
    private lazy var bubbleImageView = UIImageView().then {
        $0.image = WALIcon.imgMainBubble.image
        $0.contentMode = .scaleToFill
        $0.addSubview(bubbleLabel)
        // TODO: - 음성메세지 기능 추가 후 false로 변경
        $0.isHidden = true
    }
    
    private var bubbleLabel = UILabel().then {
        $0.text = "왈뿡이를 탭하면 소리가 나와요!"
        $0.textColor = .white100
        $0.font = WALFont.body8.font
        // TODO: - 음성메세지 기능 추가 후 false로 변경
        $0.isHidden = true
    }
    
    private var imageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.isUserInteractionEnabled = true
    }
    
    private var contentLabel = UILabel().then {
        $0.font = WALFont.body3.font
        $0.textColor = .black100
        $0.numberOfLines = 0
        $0.isHidden = false
        $0.textAlignment = .center
    }
    
    // MARK: - Property
    
    var walCategoryType: WalCategoryType = .none {
        didSet {
            imageView.image = walCategoryType.walImage
        }
    }
    
    var content: String = "" {
        didSet {
            configureContentLabel()
            updateContentLabelLayout()
        }
    }
    
    // MARK: - Initializer
    
    init() {
        super.init(frame: .zero)
        configUI()
        setupLayout()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Init UI
    
    private func configUI() {
        backgroundColor = .white100
    }
    
    private func setupLayout() {
        addSubviews([bubbleImageView, imageView, contentLabel])
        
        bubbleImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(191.91)
            $0.height.equalTo(38.23)
        }
        
        bubbleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(6.23)
            $0.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(bubbleImageView.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(88)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(46)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(313)
        }
    }
    
    private func configureContentLabel() {
        contentLabel.text = content
        contentLabel.addLineSpacing(spacing: 28)
        contentLabel.textAlignment = .center
    }
    
    private func updateContentLabelLayout() {
        let numberOfLines: NumberOfContentLabel = NumberOfContentLabel(rawValue: contentLabel.countCurrentLines()) ?? .five
        
        contentLabel.snp.updateConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(numberOfLines.topConstraints)
        }
        
//        if numberOfLines == 1 {
//            contentLabel.snp.updateConstraints {
//                $0.top.equalTo(imageView.snp.bottom).offset(74)
//            }
//        } else if numberOfLines == 2 {
//            contentLabel.snp.updateConstraints {
//                $0.top.equalTo(imageView.snp.bottom).offset(60)
//            }
//        } else if numberOfLines == 3 {
//            contentLabel.snp.updateConstraints {
//                $0.top.equalTo(imageView.snp.bottom).offset(46)
//            }
//        } else if numberOfLines == 4 {
//            contentLabel.snp.updateConstraints {
//                $0.top.equalTo(imageView.snp.bottom).offset(32)
//            }
//        } else {
//            contentLabel.snp.updateConstraints {
//                $0.top.equalTo(imageView.snp.bottom).offset(18)
//            }
//        }
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchupWal))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - @objc
    
    @objc func touchupWal() {
        bubbleImageView.isHidden = true
    }
}
