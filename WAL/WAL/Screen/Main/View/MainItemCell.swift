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
    
    private let defaultAnimationView: LottieAnimationView = .init(name: "orangePaw").then {
        $0.isHidden = true
    }
    
    private let specialAnimationView: LottieAnimationView = .init(name: "mintPaw").then {
        $0.isHidden = true
    }
    
    private var content: String = ""
    
    private var type: WalDataType = .morning
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        defaultAnimationView.isHidden = true
        defaultAnimationView.stop()
        specialAnimationView.isHidden = true
        specialAnimationView.stop()
        imageView.isHidden = false
    }
    
    override var isSelected: Bool {
        didSet {
            delegate?.selectedCell(content: content)
            
            if isSelected {
                contentView.layer.borderColor = type == .special ? UIColor.mint100.cgColor : UIColor.orange100.cgColor
                imageView.image = type == .special ? WALIcon.imgPawSpecial.image : WALIcon.imgPawActive.image
                imageView.isHidden = false
                
                if type == .special {
                    specialAnimationView.isHidden = true
                } else {
                    defaultAnimationView.isHidden = true
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
    
    func setupData(_ data: TodayWal) {
        let catetoryType = data.getCategoryType()
        type = catetoryType == .reservation ? .special : .morning
        
        if data.getOpenStatus() {
            handleShowStatus(data.getShowStatus())
        } else {
            imageView.image = WALIcon.imgPawInAtive.image
        }
        
        if let _message = data.message {
            content = _message
        } else {
            content = "-"
        }
    }
    
    private func handleShowStatus(_ showStatus: Bool) {
        if showStatus {
            imageView.image = type == .special ? WALIcon.imgPawSpecial.image : WALIcon.imgPawActive.image
            
            imageView.isHidden = false
            defaultAnimationView.isHidden = true
            specialAnimationView.isHidden = true
        } else {
            imageView.isHidden = true
            
            specialAnimationView.isHidden = type == .special ? false : true
            defaultAnimationView.isHidden = type == .special ? true : false
            
            if type == .special {
                specialAnimationView.play()
                defaultAnimationView.stop()
            } else {
                specialAnimationView.stop()
                defaultAnimationView.play()
            }
        }
    }
}
