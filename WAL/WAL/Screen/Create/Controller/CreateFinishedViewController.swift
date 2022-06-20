//
//  CreateFinishedViewController.swift
//  WAL
//
//  Created by 배은서 on 2022/05/13.
//

import UIKit

import Then
import WALKit

class CreateFinishedViewController: UIViewController {

    // MARK: - Properties
    
    private let illustView = UIView().then {
        $0.backgroundColor = UIColor.gray400
        $0.makeRound(radius: 20)
    }
    
    private let reservationFinishedLabel = UILabel().then {
        $0.font = WALFont.title1.font
        $0.textColor = UIColor.black100
        $0.text = "예약 완료"
    }
    
    private let dateLabel = UILabel().then {
        $0.textColor = UIColor.mint100
        $0.font = WALFont.body3.font
    }
    
    private let textLabel = UILabel().then {
        $0.text = "에"
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = "왈소리를 보내드릴게요!"
    }
    
    private lazy var dateLabelStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 3
        $0.addArrangedSubviews([dateLabel, textLabel])
    }
    
    private lazy var mainButton = UIButton().then {
        $0.titleLabel?.font = WALFont.body1.font
        $0.setTitle("메인으로 돌아가기", for: .normal)
        $0.setTitleColor(UIColor.white100, for: .normal)
        $0.backgroundColor = UIColor.orange100
        $0.layer.cornerRadius = 22
        $0.addTarget(self, action: #selector(touchUpMainButton), for: .touchUpInside)
    }
    
    var date: String = "" {
        didSet {
            dateLabel.text = date
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupLayout()
    }
    
    // MARK: - InitUI
    
    private func configUI() {
        view.backgroundColor = UIColor.white100
        
        [textLabel, descriptionLabel].forEach {
            $0.font = WALFont.body3.font
            $0.textColor = UIColor.black100
        }
        
    }
    
    private func setupLayout() {
        view.addSubviews([illustView,
                          reservationFinishedLabel,
                          dateLabelStackView,
                          descriptionLabel,
                          mainButton])
        
        illustView.snp.makeConstraints {
            $0.top.equalTo(view.layoutMarginsGuide).inset(164)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(173)
            $0.width.equalTo(164)
        }
        
        reservationFinishedLabel.snp.makeConstraints {
            $0.top.equalTo(illustView.snp.bottom).offset(22)
            $0.centerX.equalToSuperview()
        }
        
        dateLabelStackView.snp.makeConstraints {
            $0.top.equalTo(reservationFinishedLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabelStackView.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
        
        mainButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.layoutMarginsGuide).inset(11)
            $0.height.equalTo(52)
        }
    }
    
    // MARK: - @objc
    
    @objc private func touchUpMainButton() {
        let mainViewController = UINavigationController(rootViewController: MainViewController())
        mainViewController.modalPresentationStyle = .overFullScreen
        present(mainViewController, animated: true)
    }
}
