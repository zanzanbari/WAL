//
//  HistoryViewController.swift
//  WAL
//
//  Created by 소연 on 2022/05/03.
//

import UIKit

import Then
import WALKit

enum ActionSheetType {
    case delete
    case reserve
}

final class HistoryViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var navigationBar = WALNavigationBar(title: "히스토리").then {
        $0.rightIcon = WALIcon.btnDelete.image
        $0.rightBarButton.addTarget(self, action: #selector(touchupCloseButton), for: .touchUpInside)
    }
    
    private var historyTableView = UITableView(frame: .zero, style: .grouped)
    
    private var historyEmptyView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
    }
    
    private var historyEmptyImageView = UIImageView().then {
        $0.image = WALIcon.icnHistoryEmpty.image
    }
    
    private var historyEmptyLabel = UILabel().then {
        $0.text = "아직 히스토리가 없어요\n나만의 왈소리를 보내보세요!"
        $0.textColor = .gray200
        $0.font = WALFont.body6.font
        $0.numberOfLines = 2
        $0.addLineSpacing(spacing: 22)
        $0.textAlignment = .center
    }
    
    private let reserveHeader = HistoryReserveHeaderView()
    private let completeHeader = HistoryCompleteHeaderView()
    
    private var sendingData = [HistoryData]()
    private var completeData = [HistoryData]()
    
    var selectedIndex: IndexPath = []
    var selectedIndices: [IndexPath] = []
    
    weak var resendWalDelegate: ResendWalDelegate?
    weak var refreshDelegate: RefreshDelegate?
    
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
        historyEmptyView.addSubviews([historyEmptyImageView, historyEmptyLabel])
        view.addSubviews([navigationBar, historyEmptyView ,historyTableView])
        
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        historyEmptyImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(248)
        }
        
        historyEmptyLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(historyEmptyImageView.snp.bottom).offset(3)
        }
        
        historyEmptyView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
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
        historyTableView.estimatedRowHeight = 125
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressCell(sender:)))
        historyTableView.addGestureRecognizer(longPress)
    }
    
    private func checkHistoryData() {
        if sendingData.isEmpty && completeData.isEmpty {
            historyTableView.isHidden = true
            historyEmptyView.isHidden = false
        } else {
            historyTableView.isHidden = false
            historyEmptyView.isHidden = true
        }
    }
    
    // MARK: - @objc
    
    @objc func longPressCell(sender: UILongPressGestureRecognizer) {
        let touchPoint = sender.location(in: historyTableView)
        if let indexPath = historyTableView.indexPathForRow(at: touchPoint) {
            guard let cell = historyTableView.cellForRow(at: indexPath) as? HistoryTableViewCell else { return }
            if cell.isContentHidden {
                switch sender.state {
                case .ended:
                    selectedIndex = []
                    UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
                        cell.coverView.alpha = 1
                    }, completion: { _ in
                        self.historyTableView.beginUpdates()
                        cell.isExpanded = false
                        cell.update()
                        self.historyTableView.endUpdates()
                        cell.coverView.isHidden = false
                    })
                default:
                    let point: CGPoint = sender.location(in: self.historyTableView.cellForRow(at: indexPath))
                    if point.y > 100 || point.y < 15 {
                        sender.state = .ended
                    }
                    selectedIndex = indexPath
                    UIView.animate(withDuration: 0.1, delay: 0, options: [], animations: {
                        self.historyTableView.beginUpdates()
                        cell.isExpanded = true
                        cell.update()
                        self.historyTableView.endUpdates()
                        cell.coverView.alpha = 0
                    }, completion: { _ in
                        cell.coverView.isHidden = true
                    })
                    cell.reserveAtLabel.isHidden = false
                }
            }
        }
    }
    
    @objc func touchupCloseButton() {
        self.refreshDelegate?.refresh(self)
        self.presentingViewController?.dismiss(animated: true)
    }
    
    func showActionSheet(type: ActionSheetType, reservationId: Int) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: { action in
            self.deleteHistoryInfo(reservationId: reservationId)
        })
        
        let cancelAction = UIAlertAction(title: "취소", style: .destructive, handler: { action in
            self.cancelHistoryInfo(reservationId: reservationId)
        })
        
        let closeAction = UIAlertAction(title: "닫기", style: .cancel, handler: nil)
        
        switch type {
        case .delete:
            optionMenu.title = "이 왈소리를 삭제하시겠어요?"
            optionMenu.addAction(deleteAction)
        case .reserve:
            optionMenu.title = "이 왈소리 예약을 취소하시겠어요?"
            optionMenu.addAction(cancelAction)
        }
        optionMenu.addAction(closeAction)
        self.present(optionMenu, animated: true)
    }
}

// MARK: - UITableView Protocol

extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndex == indexPath {
            return UITableView.automaticDimension
        }
        
        for index in selectedIndices {
            if index == indexPath {
                return UITableView.automaticDimension
            }
        }
        
        return 125
    }
    
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
            reserveHeader.countLabel.text = String(sendingData.count)
            return reserveHeader
        case 1:
            completeHeader.delegate = self
            completeHeader.title = "완료"
            completeHeader.countLabel.text = String(completeData.count)
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
        if let cell = historyTableView.cellForRow(at: indexPath) as? HistoryTableViewCell {
            cell.isExpanded.toggle()
            if cell.isExpanded {
                print("cell.isExpanded \(cell.isExpanded)")
                if indexPath.section == 1 {
                    selectedIndices[sendingData.count + indexPath.row] = indexPath
                }
                else {
                    selectedIndices[indexPath.row] = indexPath
                }
                print(selectedIndices)
            } else {
                print("cell.isExpanded \(cell.isExpanded)")
                if indexPath.section == 1 {
                    selectedIndices[sendingData.count + indexPath.row] = [-1,-1]
                } else {
                    selectedIndices[indexPath.row] = [-1,-1]
                }
                print(selectedIndices)
            }
            historyTableView.beginUpdates()
            cell.update()
            historyTableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let resendAction = UIContextualAction(style: .normal, title: "재전송") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            self.resendWalDelegate?.resendToCreate(self, walsound: "\(self.completeData[indexPath.row].message)")
            self.presentingViewController?.dismiss(animated: true)
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
                self.showActionSheet(type: .reserve, reservationId: cell.postId)
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
                self.showActionSheet(type: .delete, reservationId: cell.postId)
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
            cell.selectionStyle = .none
            cell.setData(sendingData[indexPath.row])
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.cellIdentifier) as? HistoryTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.setData(completeData[indexPath.row])
            cell.hideDdayView()
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
        HistoryAPI.shared.getHistoryData { [weak self] historyData, statusCode in
            guard let self else { return }
            guard let _statusCode = statusCode else { return }
            
            let networkResult = NetworkResult(rawValue: _statusCode) ?? .none
            switch networkResult {
            case .okay:
                guard let historyData = historyData else { return }
                
                if let sendingData = historyData.notDoneData {
                    self.sendingData = sendingData
                    for _ in 0 ..< sendingData.count {
                        self.selectedIndices.append([-1,-1])
                    }
                }
                
                if let completeData = historyData.doneData {
                    self.completeData = completeData
                    for _ in 0 ..< completeData.count {
                        self.selectedIndices.append([-1,-1])
                    }
                }
                
                DispatchQueue.main.async {
                    self.checkHistoryData()
                    self.historyTableView.reloadData()
                }
                
            default:
                self.showToast(message: "Error: \(_statusCode)")
            }
            
        }
    }
    
    func getHistoryInfoAfterDelete() {
        selectedIndices = []
        HistoryAPI.shared.getHistoryData { [weak self] historyData, statusCode in
            guard let self else { return }
            guard let _statusCode = statusCode else { return }
            
            let networkResult = NetworkResult(rawValue: _statusCode) ?? .none
            switch networkResult {
            case .okay:
                guard let historyData = historyData else { return }
                if let sendingData = historyData.notDoneData {
                    self.sendingData = sendingData
                    for _ in 0 ..< sendingData.count {
                        self.selectedIndices.append([-1,-1])
                    }
                }
                if let completeData = historyData.doneData {
                    self.completeData = completeData
                    for _ in 0 ..< completeData.count {
                        self.selectedIndices.append([-1,-1])
                    }
                }
                
                DispatchQueue.main.async {
                    self.checkHistoryData()
                    self.historyTableView.reloadSections(IndexSet(0...1), with: .none)
                }
            default:
                self.showToast(message: "Error: \(_statusCode)")
            }
        }
    }
    
    func cancelHistoryInfo(reservationId: Int) {
        HistoryAPI.shared.cancelHistoryData(reservationId: reservationId) { [weak self] cancelHistoryData, statusCode in
            guard let self else { return }
            guard let _statusCode = statusCode else { return }
            
            let networkResult = NetworkResult(rawValue: _statusCode) ?? .none
            switch networkResult {
            case .okay:
                guard let cancelHistoryData = cancelHistoryData else { return }
                print("[cancelHistoryData] DEBUG: - \(cancelHistoryData)")
                self.getHistoryInfoAfterDelete()
            default:
                self.showToast(message: "Error: \(_statusCode)")
            }
            
        }
    }
    
    func deleteHistoryInfo(reservationId: Int) {
        HistoryAPI.shared.deleteHistoryData(reservationId: reservationId) { [weak self] deleteHistoryData, statusCode in
            guard let self else { return }
            guard let _statusCode = statusCode else { return }
            
            let networkResult = NetworkResult(rawValue: _statusCode) ?? .none
            switch networkResult {
            case .okay:
                guard let deleteHistoryData = deleteHistoryData else { return }
                print("[deleteHistoryData] DEBUG: - \(deleteHistoryData)")
                self.getHistoryInfoAfterDelete()
            default:
                self.showToast(message: "Error: \(_statusCode)")
            }
        }
    }
    
}
