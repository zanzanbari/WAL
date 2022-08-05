//
//  ResignViewController.swift
//  WAL
//
//  Created by heerucan on 2022/06/27.
//

import UIKit

import Then
import WALKit

final class ResignViewController: UIViewController {
    
    // MARK: - Properties
    
    private let setting = SettingData()
    
    private let navigationBar = WALNavigationBar(title: "왈 탈퇴").then {
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
        $0.allowsSelection = true
        $0.delegate = self
        $0.dataSource = self
        $0.sectionHeaderTopPadding = 0
    }
    
    private let resignButton = WALPlainButton().then {
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
        
        resignButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(UIScreen.main.hasNotch ? 50 : 26)
        }
    }
    
    private func setupTableView() {
        tableView.register(ResignTableViewCell.self, forCellReuseIdentifier: ResignTableViewCell.identifier)
    }

    // MARK: - Custom Method
    
    // MARK: - @objc
    
    @objc func touchupBackButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func touchupResignButton() {
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            
        } else if indexPath.row == 1 {
            
        }
    }
}

// MARK: - UITableViewDataSource

extension ResignViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return ResignHeaderView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
        
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setting.getSettingCount(setting.resignRowData)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "ResignTableViewCell", for: indexPath) as? ResignTableViewCell
        else { return UITableViewCell() }
        cell.menuLabel.text = setting.getMenuLabel(setting.resignRowData, indexPath.row)
        return cell
    }
}
