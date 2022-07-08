//
//  CreateBackPopupViewController.swift
//  WAL
//
//  Created by 배은서 on 2022/07/08.
//

import UIKit

class CreateBackPopupViewController: UIViewController {

    // MARK: - Properties
    
    private lazy var backPopupView = WALPopupView(title: "왈소리 만들기 나가기", subTitle: "작성 중인 내용이 사라져요.", rightButtonColor: .mint100).then {
        $0.leftText = "취소"
        $0.rightText = "나가기"
        $0.leftButton.addTarget(self, action: #selector(touchUpCancelButton), for: .touchUpInside)
        $0.rightButton.addTarget(self, action: #selector(touchUpOkButton), for: .touchUpInside)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupLayout()
    }
    
    // MARK: - InitUI
    
    private func configUI() {
        view.backgroundColor = .black100.withAlphaComponent(0.5)
    }
    
    private func setupLayout() {
        view.addSubview(backPopupView)
        
        backPopupView.snp.makeConstraints {
            $0.height.equalTo(154)
            $0.width.equalTo(295)
            $0.center.equalToSuperview()
        }
    }
    
    //MARK: - @objc
    
    @objc func touchUpCancelButton() {
        dismiss(animated: true)
    }
    
    @objc func touchUpOkButton() {
        guard let createViewController = presentingViewController else { return }
        
        dismiss(animated: true) {
            createViewController.navigationController?.popViewController(animated: true)
        }
    }
}
