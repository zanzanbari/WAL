//
//  ZanzanbariViewController.swift
//  WAL
//
//  Created by heerucan on 2022/08/05.
//

import UIKit

import SafariServices
import WALKit
import Then

final class ZanzanbariViewController: UIViewController {

    // MARK: - Properties
    
    private let statusBarView = UIView()
    
    private lazy var navigationBar = WALNavigationBar(title: Constant.NavigationTitle.zanzan).then {
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
        $0.backgroundColor = .gray500
    }
    
    private let designView = ZanzanView().then {
        $0.image = WALIcon.icnDesigner.image
        $0.partType = .etc
        $0.part = "Design"
        $0.firstName = "김준희"
        $0.secondName = "이지원"
    }
    
    private let iOSView = ZanzanView().then {
        $0.image = WALIcon.icnDeveloper.image
        $0.partType = .iOS
        $0.part = "iOS"
        $0.firstName = "김루희"
        $0.secondName = "김소연"
        $0.thirdName = "배은서"
        $0.fourthName = "최이준"
    }
    
    private let serverView = ZanzanView().then {
        $0.image = WALIcon.icnServer.image
        $0.partType = .etc
        $0.part = "Server"
        $0.firstName = "조찬우"
        $0.secondName = "최진영"
    }
    
    private let buttonBackView = UIView()
    
    private lazy var sendOpinionButton = UIButton(type: .system).then {
        $0.setTitle("팀 쟌쟌바리에게 의견 보내기", for: .normal)
        $0.setTitleColor(.black100, for: .normal)
        $0.titleLabel?.font = WALFont.body7.font
        $0.addTarget(self, action: #selector(touchupSendOpinionButton), for: .touchUpInside)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupLayout()
    }
    
    // MARK: - InitUI
    
    private func configUI() {
        view.backgroundColor = .gray600
        [statusBarView, backView, buttonBackView].forEach {
            $0.backgroundColor = .white100
        }
    }
    
    private func setupLayout() {
        view.addSubviews([statusBarView,
                          navigationBar,
                          backView,
                          buttonBackView])
        backView.addSubviews([titleLabel,
                              subtitleLabel,
                              lineView,
                              designView,
                              iOSView,
                              serverView])
        buttonBackView.addSubview(sendOpinionButton)
        
        statusBarView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(navigationBar.snp.top)
        }
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        backView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(497)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(55)
            make.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview().inset(68)
            make.height.equalTo(1)
        }
        
        designView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(36)
            make.leading.equalToSuperview().inset(95)
        }
        
        iOSView.snp.makeConstraints { make in
            make.top.equalTo(designView.snp.bottom).offset(40)
            make.leading.equalTo(designView)
        }
        
        serverView.snp.makeConstraints { make in
            make.top.equalTo(iOSView.snp.bottom).offset(37)
            make.leading.equalTo(designView)
        }
        
        buttonBackView.snp.makeConstraints { make in
            make.top.equalTo(backView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(62)
        }
        
        sendOpinionButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - @objc
    
    @objc func touchupBackButton() {
        transition(self, .pop)
    }
    
    @objc func touchupSendOpinionButton() {
        guard let url = NSURL(string: Constant.URL.walURL) else { return }
        let safariView: SFSafariViewController = SFSafariViewController(url: url as URL)
        transition(safariView, .present)
    }
}
