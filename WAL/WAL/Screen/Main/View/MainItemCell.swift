//
//  TempView.swift
//  WAL
//
//  Created by Thisisme Hi on 2022/04/01.
//

import UIKit

import WALKit

import Lottie

// MARK: - ItemCell

protocol MainItemCellDelegate: AnyObject {
    func selectedCell(content: String)
}

final class MainItemCell: UICollectionViewCell {
    static var cellIdentifier: String { return String(describing: self) }
    
    private var imageView = UIImageView().then {
        $0.image = WALIcon.imgPawInAtive.image
        $0.contentMode = .scaleAspectFit
        $0.isHidden = false
    }
    
    private let defaultAnimationView: AnimationView = .init(name: "orangePaw").then {
        $0.isHidden = true
    }
    
    private let specialAnimationView: AnimationView = .init(name: "mintPaw").then {
        $0.isHidden = true
    }
    
    private var content: String = ""
    
    private var type: WALDataType = .morning
    
    weak var delegate: MainItemCellDelegate?
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            delegate?.selectedCell(content: content)
            
            if isSelected {
                if type == .special {
                    contentView.layer.borderColor = UIColor.mint100.cgColor
                } else {
                    contentView.layer.borderColor = UIColor.orange100.cgColor
                }
            } else {
                contentView.layer.borderColor = UIColor.gray400.cgColor
            }
        }
    }
    
    private func configUI() {
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray400.cgColor
        contentView.layer.cornerRadius = 10
        
        [defaultAnimationView,specialAnimationView].forEach {
            $0.frame = contentView.bounds
            $0.center = contentView.center
            $0.contentMode = .scaleAspectFill
            $0.play()
            $0.loopMode = .loop
        }
    }
    
    private func setupLayout() {
        addSubview(imageView)
        addSubviews([defaultAnimationView, specialAnimationView])
        
        imageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(18)
        }
    }
    
    internal func setupData(_ data: MainResponse) {
        if data.type == "스페셜" {
            type = .special
        } else {
            type = .morning
        }
        
        if data.canOpen {
            if type == .special {
                imageView.isHidden = true
                defaultAnimationView.isHidden = true
                specialAnimationView.isHidden = false
            } else {
                imageView.isHidden = true
                defaultAnimationView.isHidden = false
                specialAnimationView.isHidden = true
            }
        } else {
            imageView.image = WALIcon.imgPawInAtive.image
        }
        
        self.content = data.content
    }
}


