//
//  SettingViewController.swift
//  WAL
//
//  Created by heerucan on 2022/05/05.
//

import UIKit

import WALKit

final class SettingViewController: UIViewController {
    
    // MARK: - Properties
    
    private let setting = SettingData()
    
    private let navigationBar = WALNavigationBar(title: "설정").then {
        $0.backgroundColor = .white100
        $0.leftIcon = WALIcon.btnBack.image
        $0.leftBarButton.addTarget(self, action: #selector(touchupBackButton), for: .touchUpInside)
    }
    
    private let backView = UIView().then {
        $0.backgroundColor = .white100
    }
    
    private lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .gray600
        $0.separatorStyle = .none
        $0.allowsSelection = true
        $0.delegate = self
        $0.dataSource = self
        $0.sectionHeaderTopPadding = 0
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupLayout()
        setupTableView()
    }
    
    // MARK: - InitUI
    
    private func configUI() {
        view.backgroundColor = .white100
    }
    
    private func setupLayout() {
        view.addSubviews([navigationBar, tableView, backView])
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(47)
            make.leading.trailing.equalToSuperview()
        }
        
        backView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    private func setupTableView() {
        tableView.register(MyInfoTableViewCell.self, forCellReuseIdentifier: MyInfoTableViewCell.identifier)
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
    }
    
    // MARK: - Custom Method
    
    // MARK: - @objc
    
    @objc func touchupBackButton() {
        // MARK: - FIXME 회원탈퇴 코드 환경설정 뷰에 알맞은 곳에 넣기
        guard let socialLogin = GeneralAPI.socialLogin,
              let socialToken = GeneralAPI.socialToken else { return }
        AuthAPI.shared.postResign(
            social: socialLogin, socialToken: socialToken) { (resignData, err) in
                guard let resignData = resignData else { return }
                print("-------회원탈퇴 서버 통신", resignData)
            }
        // MARK: - FIXME 로그아웃 코드 환경설정 뷰에 알맞은 곳에 넣기
        AuthAPI.shared.getLogout { logoutData, err in
            guard let logoutData = logoutData else { return }
            print("--------로그아웃 서버 통신 : ", logoutData)
        }
    }
}

// MARK: - UITableViewDelegate

extension SettingViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            backView.snp.updateConstraints { make in
                make.height.equalTo(-scrollView.contentOffset.y)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 1:
            if indexPath.row == 0 {
                let viewController = SettingAlarmViewController()
                viewController.modalPresentationStyle = .overFullScreen
                present(viewController, animated: true, completion: nil)
            }
        default:
            break
        }
    }
}

// MARK: - UITableViewDataSource

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1, 2: return 10
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return setting.getSettingCount(setting.firstRowData)
        case 2: return setting.getSettingCount(setting.secondRowData)
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "MyInfoTableViewCell", for: indexPath) as? MyInfoTableViewCell
            else { return UITableViewCell() }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "SettingTableViewCell", for: indexPath) as? SettingTableViewCell
            else { return UITableViewCell() }
            cell.menuLabel.text = setting.getMenuLabel(setting.firstRowData, indexPath.row)
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "SettingTableViewCell", for: indexPath) as? SettingTableViewCell
            else { return UITableViewCell() }
            cell.setupData(index: indexPath.row)
            return cell
            
        default: return UITableViewCell()
        }
    }
}
