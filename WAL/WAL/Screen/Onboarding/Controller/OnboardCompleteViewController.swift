//
//  OnboardCompleteViewController.swift
//  WAL
//
//  Created by heerucan on 2022/08/05.
//

import UIKit

import SnapKit
import Then
import WALKit

final class OnboardCompleteViewController: UIViewController {

    // MARK: - Properties
    
    private let completeImageView = UIImageView().then {
        $0.image = WALIcon.icnSettingComplete.image
    }
    
    private let completeLabel = UILabel().then {
        $0.text = "맞춤 설정 완료"
        $0.font = WALFont.cafe24.font
        $0.textAlignment = .center
    }
    
    private let subLabel = UILabel().then {
        $0.text = "쟌쟌바리님 맞춤 설정을 끝냈어요\n왈을 시작해볼까요?"
        $0.font = WALFont.body5.font
        $0.numberOfLines = 2
        $0.textColor = .gray100
        $0.textAlignment = .center
    }
    
    private let startButton = WALPlainButton().then {
        $0.title = "시작하기"
        $0.isDisabled = false
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupLayout()
    }
    
    // MARK: - InitUI
    
    private func configUI() {
        view.backgroundColor = .white
    }
    
    private func setupLayout() {
        view.addSubviews([completeImageView,
                          completeLabel,
                          subLabel,
                          startButton])
        
        completeImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(180)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(230)
        }
        
        completeLabel.snp.makeConstraints { make in
            make.top.equalTo(completeImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(completeLabel.snp.bottom).offset(17)
            make.centerX.equalToSuperview()
        }
        
        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(52)
        }
    }
    
    // MARK: - Custom Method


}
