//
//  WALPlainButton.swift
//  WAL
//
//  Created by heerucan on 2022/05/01.
//

import UIKit

public class WALPlainButton: UIButton {
    
    // MARK: - Property
        
    public var title: String? {
        didSet {
            setTitle(title, for: .normal)
        }
    }
    
    public var isDisabled: Bool = false {
        didSet {
            isEnabled = !isDisabled
            setupColor()
        }
    }

    // MARK: - Initialize
    
    public init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
    
    private func setupUI() {
        titleLabel?.font = WALFont.body2.font
        layer.cornerRadius = Matrix.buttonCornerRadius
        setTitleColor(.white100, for: .normal)
        setTitleColor(.orange50, for: .highlighted)
        setupColor()
    }
    
    private func setupLayout() {
        snp.makeConstraints { make in
            make.height.equalTo(Matrix.buttonHeight)
        }
    }
    
    private func setupColor() {
        backgroundColor = .orange100
        
        if isDisabled {
            backgroundColor = .gray400
        }
    }
}
