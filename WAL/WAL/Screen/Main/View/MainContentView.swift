//
//  MainContentView.swift
//  WAL
//
//  Created by 소연 on 2022/06/16.
//

import UIKit

import WALKit

import Lottie

enum WALContentType {
    case fun
    case angry
    case cheer
    case love
    
    var walImage: UIImage {
        switch self {
        case .fun:
            return WALIcon.imgWallbbongFun.image
        case .angry:
            return WALIcon.imgWallbbongAngry.image
        case .cheer:
            return WALIcon.imgWallbbongCheer.image
        case .love:
            return WALIcon.imgWallbbongLove.image
        }
    }
}

final class MainContentView: UIView {
    
    private lazy var bubbleImageView = UIImageView().then {
        $0.image = WALIcon.imgMainBubble.image
        $0.contentMode = .scaleToFill
        $0.addSubview(bubbleLabel)
    }
    
    private var bubbleLabel = UILabel().then {
        $0.text = "왈뿡이를 탭하면 소리가 나와요!"
        $0.textColor = .white100
        $0.font = WALFont.body8.font
    }
    
    private var imageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.isUserInteractionEnabled = true
    }
    
    private var contentLabel = UILabel().then {
        $0.font = WALFont.body3.font
        $0.textColor = .gray100
        $0.numberOfLines = 0
        $0.isHidden = false
        $0.textAlignment = .center
    }
    
    private lazy var shareButton = UIButton().then {
        $0.setTitle("공유", for: .normal)
        $0.setTitleColor(.white100, for: .normal)
        $0.backgroundColor = .mint100
        $0.titleLabel?.font = WALFont.body4.font
        $0.layer.cornerRadius = 20
        $0.addTarget(self, action: #selector(touchUpShareButton), for: .touchUpInside)
    }
    
    var walContentType: WALContentType = .fun {
        didSet {
            imageView.image = walContentType.walImage
        }
    }
    
    var content: String = "" {
        didSet {
            contentLabel.text = content
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
        addSubviews([bubbleImageView, imageView, contentLabel, shareButton])
        
        bubbleImageView.addSubview(bubbleLabel)
        
        bubbleImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(1)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(191.91)
            $0.height.equalTo(38.23)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(bubbleImageView.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(88)
        }
        
        bubbleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(6.23)
            $0.centerX.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(46)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(313)
        }
        
        shareButton.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(79)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(97)
            $0.height.equalTo(40)
        }
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchUpWal))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - @objcd
    
    @objc func touchUpWal() {
        print("왈뿡이 탭했음요")
        bubbleImageView.isHidden = true
    }
    
    @objc func touchUpShareButton() {
        if let storiesUrl = URL(string: "instagram-stories://share") {
            if UIApplication.shared.canOpenURL(storiesUrl) {
                guard let image = imageView.image else { return }
                
                guard let imageData = image.pngData() else { return }
                let pasteboardItems: [String: Any] = [
                    "com.instagram.sharedSticker.stickerImage": imageData,
                    "com.instagram.sharedSticker.backgroundTopColor": "#636e72",
                    "com.instagram.sharedSticker.backgroundBottomColor": "#b2bec3"
                ]
                let pasteboardOptions = [
                    UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)
                ]
                UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
                UIApplication.shared.open(storiesUrl, options: [:], completionHandler: nil)
            } else {
                print("디바이스에 인스타그램이 없는데요")
            }
        }
    }
}
