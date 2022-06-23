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
    
    private let animationView: AnimationView = .init(name: "mintPaw").then {
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
                if type == .speacial {
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
        
        animationView.frame = contentView.bounds
        animationView.center = contentView.center
        animationView.contentMode = .scaleAspectFill
        animationView.play()
        animationView.loopMode = .loop
    }
    
    private func setupLayout() {
        addSubview(imageView)
        addSubview(animationView)
        
        imageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(18)
        }
    }
    
    internal func setupData(_ data: MainDataModel) {
        if data.type == "스페셜" {
            type = .speacial
            
            // MARK: TODO REMOVE - 로티 확인용
            imageView.isHidden = true
            animationView.isHidden = false
        } else {
            type = .morning
        }
        
        if data.canOpen {
            if type == .speacial {
                imageView.image = WALIcon.imgPawSpecial.image
            } else {
                imageView.image = WALIcon.imgPawActive.image
            }
        } else {
            imageView.image = WALIcon.imgPawInAtive.image
        }
        
        self.content = data.content
    }
}


