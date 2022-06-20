//
//  CreateInformationViewController.swift
//  WAL
//
//  Created by 배은서 on 2022/06/20.
//

import UIKit

import Then
import WALKit

class CreateInformationViewController: UIViewController {
    
    // MARK: - Properties
    
    private let informationView = UIView().then {
        $0.backgroundColor = .white100
        $0.makeRound(radius: 20)
    }
    
    private lazy var closeButton = UIButton().then {
        $0.setImage(WALKit.WALIcon.btnDelete.image, for: .normal)
        $0.addTarget(self, action: #selector(touchUpCloseButton), for: .touchUpInside)
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "왈소리 만들기란?"
        $0.font = WALKit.WALFont.title2.font
        $0.textColor = .black100
    }
    
    private let imageView = UIImageView().then {
        $0.image = WALKit.WALIcon.icnApple.image
    }
    
    private let subTitleLabel = UILabel().then {
        $0.text = """
                    직접 만들어 더욱 특별한 왈소리를
                    원하는 날, 나에게 보내보세요!
                  """
        $0.font = WALKit.WALFont.body7.font
        $0.addLineSpacing(spacing: 21)
        $0.textColor = .black100
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = """
                    ・ 선택한 날짜에 1개의 왈소리만 보낼 수 있어요
                    ・ 내가 보낸 왈소리에는 음성이 없어요
                    ・ 보낸 왈소리는 히스토리에서 확인 가능해요
                  """
        $0.font = WALKit.WALFont.body9.font
        $0.addLineSpacing(spacing: 22)
        $0.textColor = .gray100
        $0.numberOfLines = 3
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupLayout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: false)
    }
    
    // MARK: - InitUI
    
    private func configUI() {
        view.backgroundColor = .black100.withAlphaComponent(0.7)
    }
    
    private func setupLayout() {
        view.addSubviews([informationView,
                          closeButton,
                          titleLabel,
                          imageView,
                          subTitleLabel,
                          descriptionLabel])
        
        informationView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(279)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.trailing.equalTo(informationView).inset(7)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(informationView.snp.top).inset(49)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(17)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(22)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(20)
            $0.bottom.equalTo(informationView.snp.bottom).inset(36)
        }
        
        [titleLabel, imageView, subTitleLabel, descriptionLabel].forEach {
            $0.snp.makeConstraints {
                $0.centerX.equalTo(informationView.snp.centerX)
            }
        }
    }
    
    //MARK: - @objc
    
    @objc private func touchUpCloseButton() {
        dismiss(animated: false)
    }
    
    // MARK: - Custom Method
}
