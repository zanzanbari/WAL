//
//  HistoryViewController.swift
//  WAL
//
//  Created by 소연 on 2022/05/03.
//

import UIKit

import Then

import WALKit

final class HistoryViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var navigationBar = WALNavigationBar(title: "히스토리").then {
        $0.rightIcon = WALIcon.btnDelete.image
        $0.rightBarButton.addTarget(self, action: #selector(touchupCloseButton), for: .touchUpInside)
    }
    
    private var historyTableView = UITableView(frame: .zero, style: .grouped)
    
    private let reserveHeader = HistoryReserveHeaderView()
    private let completeHeader = HistoryCompleteHeaderView()
    
    private var expandCellDatasource =  ExpandTableViewCellContent()
    
    private var sendingData = [HistoryData]()
    private var completeData = [HistoryData]()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupLayout()
        setupTableView()
        getHistoryInfo()
    }
    
    // MARK: - Init UI
    
    private func configUI() {
        view.backgroundColor = .white
    }
    
    private func setupLayout() {
        view.addSubviews([navigationBar, historyTableView])
        
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        historyTableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Custom Method
    
    private func setupTableView() {
        historyTableView.backgroundColor = .clear
        
        historyTableView.delegate = self
        historyTableView.dataSource = self
        historyTableView.register(HistoryTableViewCell.self,
                                  forCellReuseIdentifier: HistoryTableViewCell.cellIdentifier)
        
        historyTableView.separatorStyle = .none
        historyTableView.rowHeight = 125
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressCell(sender:)))
        historyTableView.addGestureRecognizer(longPress)
    }
    
    // MARK: - @objc
    
    @objc func longPressCell(sender: UILongPressGestureRecognizer) {
        let touchPoint = sender.location(in: historyTableView)
        if let indexPath = historyTableView.indexPathForRow(at: touchPoint) {
            guard let cell = historyTableView.cellForRow(at: indexPath) as? HistoryTableViewCell else { return }
            let content = expandCellDatasource
            
            if cell.isContentHidden {
                let touchPoint = sender.location(in: historyTableView)
                if let indexPath = historyTableView.indexPathForRow(at: touchPoint) {
                    if content.isExpanded {
                        historyTableView.rowHeight = 125
                    } else {
                        historyTableView.rowHeight = UITableView.automaticDimension
                    }
                    content.isExpanded.toggle()
                    
                    historyTableView.reloadRows(at: [indexPath], with: .automatic)
                    
                    guard let cell = historyTableView.cellForRow(at: indexPath) as? HistoryTableViewCell else { return }
                    cell.isPressed = (sender.state == .began) ? false : true
                }
            }
            
        }
    }
    
    @objc func touchupCloseButton() {
        dismiss(animated: true)
    }
}

// MARK: - UITableView Protocol

extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 52
        case 1:
            return 70
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            reserveHeader.title = "보내는 중"
            return reserveHeader
        case 1:
            completeHeader.delegate = self
            completeHeader.title = "완료"
            return completeHeader
        default:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        historyTableView.rowHeight = UITableView.automaticDimension
        
        let content = expandCellDatasource
        content.isExpanded.toggle()
        
        historyTableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let resendAction = UIContextualAction(style: .normal, title: "재전송") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
//            dismiss(animated: true)
            success(true)
        }
        resendAction.backgroundColor = .mint100
        
        if let cell = historyTableView.cellForRow(at: indexPath) as? HistoryTableViewCell {
            cell.contentView.frame = cell.contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0))
            if cell.isExpanded {
                resendAction.image = WALIcon.icnReturn.image
            } else {
                resendAction.image = nil
            }
        }
        
        let cancelAction = UIContextualAction(style: .normal, title: "예약 취소") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            if let cell = self.historyTableView.cellForRow(at: indexPath) as? HistoryTableViewCell {
                DispatchQueue.main.async {
                    self.cancelHistoryInfo(postId: cell.postId)
                }
            }
            success(true)
        }
        cancelAction.backgroundColor = .orange100
        
        if let cell = historyTableView.cellForRow(at: indexPath) as? HistoryTableViewCell {
            if cell.isExpanded {
                cancelAction.image = WALIcon.icnTrash.image
            } else {
                cancelAction.image = nil
            }
        }
        
        let deleteAction = UIContextualAction(style: .normal, title: "삭제") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            if let cell = self.historyTableView.cellForRow(at: indexPath) as? HistoryTableViewCell {
                DispatchQueue.main.async {
                    self.deleteHistoryInfo(postId: cell.postId)
                }
            }
            success(true)
        }
        deleteAction.backgroundColor = .orange100
        
        if let cell = historyTableView.cellForRow(at: indexPath) as? HistoryTableViewCell {
            if cell.isExpanded {
                deleteAction.image = WALIcon.icnTrash.image
            } else {
                deleteAction.image = nil
            }
        }
        
        if indexPath.section == 0 {
            return UISwipeActionsConfiguration(actions: [cancelAction])
        } else {
            return UISwipeActionsConfiguration(actions: [deleteAction, resendAction])
        }
    }
}

extension HistoryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return sendingData.count
        case 1:
            return completeData.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.cellIdentifier) as? HistoryTableViewCell else { return UITableViewCell() }
            cell.initCell(isTapped: expandCellDatasource)
            cell.selectionStyle = .none
            cell.sendingDateLabelColor = .systemMint
            cell.setData(sendingData[indexPath.row])
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.cellIdentifier) as? HistoryTableViewCell else { return UITableViewCell() }
            cell.initCell(isTapped: expandCellDatasource)
            cell.selectionStyle = .none
            cell.sendingDateLabelColor = .gray
            cell.setData(completeData[indexPath.row])
            return cell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - Custom Delegate

extension HistoryViewController: HistoryCompleteHeaderViewDelegate {
    func touchUpInformationButton() {
        completeHeader.informationIsHidden.toggle()
    }
}

// MARK: - Network

extension HistoryViewController {
    func getHistoryInfo() {
        HistoryAPI.shared.getHistoryData { historyData, err in
            guard let historyData = historyData else {
                return
            }
            if let sendingData = historyData.data?.sendingData {
                self.sendingData = sendingData
            }
            if let completeData = historyData.data?.completeData {
                self.completeData = completeData
            }
            DispatchQueue.main.async {
                self.historyTableView.reloadData()
            }
        }
    }
    
    func cancelHistoryInfo(postId: Int) {
        HistoryAPI.shared.cancelHistoryData(postId: postId) { cancelHistoryData, err in
            guard let cancelHistoryData = cancelHistoryData else {
                return
            }
            print(cancelHistoryData)
            self.getHistoryInfo()
        }
    }
    
    func deleteHistoryInfo(postId: Int) {
        HistoryAPI.shared.deleteHistoryData(postId: postId) { deleteHistoryData, err in
            guard let deleteHistoryData = deleteHistoryData else {
                return
            }
            print(deleteHistoryData)
            self.getHistoryInfo()
        }
    }
}
