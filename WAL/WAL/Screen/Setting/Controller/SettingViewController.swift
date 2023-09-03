//
//  SettingViewController.swift
//  WAL
//
//  Created by heerucan on 2022/05/05.
//

import UIKit

import SafariServices
import Then
import WALKit

final class SettingViewController: UIViewController, SendNicknameDelegate {
    
    // MARK: - Properties
    
    var nickname = ""
    private let setting = SettingData()
    
    private lazy var navigationBar = WALNavigationBar(title: Constant.NavigationTitle.setting).then {
        $0.backgroundColor = .white100
        $0.leftIcon = WALIcon.btnBack.image
        $0.leftBarButton.addTarget(self, action: #selector(touchupBackButton), for: .touchUpInside)
    }
    
    private let backView = UIView().then {
        $0.backgroundColor = .white100
    }
    
    private lazy var tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.backgroundColor = .gray600
        $0.separatorStyle = .none
        $0.delegate = self
        $0.dataSource = self
        $0.sectionHeaderTopPadding = 0
        $0.sectionFooterHeight = 0
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupLayout()
        requestNickname()
        setupTableView()
    }
    
    // MARK: - InitUI
    
    private func configUI() {
        view.backgroundColor = .white100
    }
    
    private func setupLayout() {
        view.addSubviews([navigationBar, tableView, backView])
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
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
        MyInfoTableViewCell.register(tableView)
        SettingTableViewCell.register(tableView)
    }

    // MARK: - @objc
    
    @objc func touchupBackButton() {
        navigationController?.popViewController(animated: true)
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
        case 0:
            let viewController = MypageViewController()
            transition(viewController)
            viewController.nickname = nickname
            viewController.sendNicknameDelegate = self
        case 1:
            if indexPath.row == 0 {
                let viewController = SettingAlarmViewController()
                transition(viewController)
            } else if indexPath.row == 1 {
                let viewController = SettingCategoryViewController()
                transition(viewController)
            }
        default:
            if indexPath.row == 0 {
                let viewController = ZanzanbariViewController()
                transition(viewController)
            } else if indexPath.row == 1 {
                guard let url = NSURL(string: Constant.URL.walURL) else { return }
                let safariView: SFSafariViewController = SFSafariViewController(url: url as URL)
                transition(safariView, .present)
            } else if indexPath.row == 2 {
                guard let url = NSURL(string: Constant.URL.serviceURL) else { return }
                let safariView: SFSafariViewController = SFSafariViewController(url: url as URL)
                transition(safariView, .present)
            }
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyInfoTableViewCell.identifier, for: indexPath) as? MyInfoTableViewCell
            else { return UITableViewCell() }
            cell.nicknameLabel.text = nickname
            cell.selectionStyle = .none
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as? SettingTableViewCell
            else { return UITableViewCell() }
            cell.menuLabel.text = setting.getMenuLabel(setting.firstRowData, indexPath.row)
            configureCellBackgroundColor(cell)
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as? SettingTableViewCell
            else { return UITableViewCell() }
            cell.setupData(index: indexPath.row)
            configureCellBackgroundColor(cell)
            return cell
            
        default: return UITableViewCell()
        }
    }
}

// MARK: - Protocol Method & Network

extension SettingViewController {
    func sendNickname(_ nickname: String) {
        self.nickname = nickname
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.tableView.reloadData()
        }
    }
    
    private func requestNickname() {
        SettingAPI.shared.getUserInfo { [weak self] (data, statusCode) in
            guard let _self = self else { return }
            guard let _statusCode = statusCode else { return }
            
            let networkResult = NetworkResult(rawValue: _statusCode) ?? .none
            switch networkResult {
            case .okay:
                guard let nickname = data?.nickname else { return }
                _self.nickname = nickname
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    _self.tableView.reloadData()
                }
            case .unAuthorized:
                _self.requestRefreshToken()
            default:
                _self.showToast(message: "Error \(_statusCode)")
            }
        }
    }
    
    private func requestRefreshToken() {
        AuthAPI.shared.postReissue { [weak self] response, statusCode in
            guard let _self = self else { return }
            guard let _statusCode = statusCode else { return }
            
            let networkResult = NetworkResult(rawValue: _statusCode) ?? .none
            switch networkResult {
            case .okay:
                _self.requestNickname()
            case .unAuthorized:
                _self.pushToLoginView()
            default:
                break
            }
        }
    }
}
