//
//  ResignViewController.swift
//  WAL
//
//  Created by heerucan on 2022/06/27.
//

import UIKit

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import Then
import WALKit

final class ResignViewController: UIViewController {
    
    // MARK: - Properties
    
    private let setting = SettingData()
    private var resignData = SettingData().resignRowData
    private var reasonData: [String] = []
    
    private lazy var navigationBar = WALNavigationBar(title: Constant.NavigationTitle.resign).then {
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
        $0.sectionHeaderHeight = UITableView.automaticDimension
    }
    
    private lazy var resignButton = WALPlainButton().then {
        $0.title = "탈퇴"
        $0.isDisabled = true
        $0.addTarget(self, action: #selector(touchupResignButton), for: .touchUpInside)
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
        view.backgroundColor = .white
    }
    
    private func setupLayout() {
        view.addSubviews([navigationBar, tableView, backView, resignButton])
        
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
        
        resignButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(UIScreen.main.hasNotch ? 50 : 26)
        }
    }
    
    private func setupTableView() {
        ResignTableViewCell.register(tableView)
    }
   
    // MARK: - @objc
    
    @objc func touchupBackButton() {
        transition(self, .pop)
    }
    
    @objc func touchupResignButton(_ sender: UIButton) {
        postResign()
    }
    
    @objc func touchupCheckButton(_ sender: UIButton) {
        resignData[sender.tag].select = !resignData[sender.tag].select
        reasonData = resignData.filter({$0.select}).map { $0.menu.rawValue }
        tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
    }
}

// MARK: - Network

extension ResignViewController {
    private func kakaoUnlink() {
        UserApi.shared.unlink {(error) in
            if let error = error {
                print("unlink()", error)
            }
            else {
                print("unlink() success.")
            }
        }
    }
    
    private func postResign() {
        let param = ResignRequest(reasons: reasonData)
        AuthAPI.shared.postResign(param: param) { [weak self] (resignData, statusCode) in
            guard let _self = self else { return }
            guard let _statusCode = statusCode else { return }
            
            let networkResult = NetworkResult(rawValue: _statusCode) ?? .none
            switch networkResult {
            case .noContent:
                _self.kakaoUnlink()
                _self.pushToLoginView()
                UserDefaultsHelper.standard.removeObject()
            case .unAuthorized:
                _self.requestRefreshToken()
            default:
                _self.showToast(message: "Error: \(_statusCode)")
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
                _self.postResign()
            case .unAuthorized:
                _self.pushToLoginView()
            default:
                break
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension ResignViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            backView.snp.updateConstraints { make in
                make.height.equalTo(-scrollView.contentOffset.y)
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension ResignViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return ResignHeaderView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setting.getResignSettingCount(setting.resignRowData)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ResignTableViewCell.identifier, for: indexPath) as? ResignTableViewCell
        else { return UITableViewCell() }
        resignButton.isDisabled = resignData.filter({ $0.select }).isEmpty ? true : false
        let value = resignData[indexPath.row].select ?
        WALIcon.icnSelectActive.image : WALIcon.icnSelectInactive.image
        cell.checkButton.setImage(value, for: .normal)
        cell.checkButton.tag = indexPath.row
        cell.setupData(index: indexPath.row)
        cell.checkButton.addTarget(self, action: #selector(touchupCheckButton(_:)), for: .touchUpInside)
        configureCellBackgroundColor(cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0)) as? ResignTableViewCell
        else { return }
        touchupCheckButton(cell.checkButton)
    }
}
