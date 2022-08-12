//
//  MainContentView.swift
//  WAL
//
//  Created by 소연 on 2022/06/16.
//

import UIKit

import WALKit
import Lottie

final class MainContentView: UIView {
    
    // MARK: - UI Property
    
    private lazy var bubbleImageView = UIImageView().then {
        $0.image = WALIcon.imgMainBubble.image
        $0.contentMode = .scaleToFill
        $0.addSubview(bubbleLabel)
        $0.isHidden = true
    }
    
    private var bubbleLabel = UILabel().then {
        $0.text = "왈뿡이를 탭하면 소리가 나와요!"
        $0.textColor = .white100
        $0.font = WALFont.body8.font
        $0.isHidden = true
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
        $0.addTarget(self, action: #selector(touchupShareButton), for: .touchUpInside)
    }
    
    // MARK: - Property
    
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
    
    let viewForRender = UIView()
    
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchupWal))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - @objc
    
    @objc func touchupWal() {
        bubbleImageView.isHidden = true
    }
    
    @objc func touchupShareButton() {
        let renderer = UIGraphicsImageRenderer(size: viewForRender.bounds.size)
        let renderImage = renderer.image { _ in
            viewForRender.drawHierarchy(in: viewForRender.bounds, afterScreenUpdates: true)
        }
        
        if let storyShareURL = URL(string: "instagram-stories://share") {
            if UIApplication.shared.canOpenURL(storyShareURL) {
                guard let imageData = renderImage.pngData() else {return}
                
                let pasteboardItems: [String: Any] = [
                    "com.instagram.sharedSticker.stickerImage": imageData,
                    "com.instagram.sharedSticker.backgroundTopColor": "#8D8D88",
                    "com.instagram.sharedSticker.backgroundBottomColor": "#8D8D88"]
                
                let pasteboardOptions = [UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)]
                
                UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
                UIApplication.shared.open(storyShareURL, options: [:], completionHandler: nil)
            } else {
                print("인스타 앱이 깔려있지 않습니다.")
            }
        }
    }
}
