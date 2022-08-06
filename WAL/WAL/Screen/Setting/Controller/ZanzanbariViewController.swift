//
//  ZanzanbariViewController.swift
//  WAL
//
//  Created by heerucan on 2022/08/05.
//

import UIKit

import WALKit
import Then

class ZanzanbariViewController: UIViewController {

    // MARK: - Properties
    
    private let navigationBar = WALNavigationBar(title: "왈이 궁금해요").then {
        $0.backgroundColor = .white100
        $0.leftIcon = WALIcon.btnBack.image
        $0.leftBarButton.addTarget(self, action: #selector(touchupBackButton), for: .touchUpInside)
    }
    
    private let backView = UIView()
    
    private let titleLabel = UILabel().then {
        $0.text = "왈을 만든 사람들"
        $0.font = WALFont.title0.font
        $0.textColor = .black100
    }
    
    private let subtitleLabel = UILabel().then {
        $0.text = "팀 쟌쟌바리"
        $0.font = WALFont.body7.font
        $0.textColor = .black100
    }
    
    private let lineView = UIView().then {
        $0.backgroundColor = .gray400
    }
    
    private let designView = ZanzanView().then {
        $0.image = WALIcon.icnDesigner.image
        $0.part = "Design"
        $0.firstName = "김준희"
        $0.secondName = "이지원"
    }
    
    private let iOSView = ZanzanView().then {
        $0.image = WALIcon.icnDeveloper.image
        $0.part = "iOS"
        $0.firstName = "김루희"
        $0.secondName = "김소연"
    }
    
    private let serverView = ZanzanView().then {
        $0.image = WALIcon.icnServer.image
        $0.part = "Server"
        $0.firstName = "조찬우"
        $0.secondName = "최진영"
    }
    
    private let iOSLabel = UILabel().then {
        $0.text = "배은서"
        $0.textColor = .black100
        $0.font = WALFont.body7.font
    }
    
//    private let desinImageView = UIImageView().then {
//        $0.image = WALIcon.icnDesigner.image
//    }
//
//    private let designLabel = UILabel().then {
//        $0.text = "Design"
//        $0.textColor = .orange100
//        $0.font = WALFont.body9.font
//    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupLayout()
    }
    
    // MARK: - InitUI
    
    private func configUI() {
        view.backgroundColor = .gray600
    }
    
    private func setupLayout() {
        view.addSubviews([navigationBar, backView])
        backView.addSubviews([titleLabel,
                              subtitleLabel,
                              lineView,
                              designView,
                              iOSView,
                              iOSLabel,
                              serverView])
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(47)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    // MARK: - Custom Method

    
    // MARK: - @objc
    
    @objc func touchupBackButton() {
        self.dismiss(animated: true, completion: nil)
    }

}
