//
//  CreateViewController.swift
//  WAL
//
//  Created by 배은서 on 2022/05/04.
//

import UIKit

import Then
import WALKit

class CreateViewController: UIViewController {
    
    // MARK: - Properties
    
    private let createView = WALCreateView()
    
    private let scrollView = UIScrollView(frame: .zero).then {
        $0.backgroundColor = .white100
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    
    private let navigationBar = WALNavigationBar(title: "왈소리 만들기").then {
        $0.leftIcon = WALIcon.btnBack.image
        $0.rightIcon = WALIcon.btnHistory.image
    }
    
    private let walSoundLabel = UILabel().then {
        $0.text = "왈소리"
        $0.font = WALFont.body2.font
        $0.textColor = .black100
    }
    
    private lazy var showInformationButton = UIButton().then {
        $0.setImage(WALIcon.btnInfo.image, for: .normal)
        $0.addTarget(self, action: #selector(touchUpInformationButton), for: .touchUpInside)
    }
    
    private lazy var walSoundTextView = UITextView().then {
        $0.font = WALFont.body5.font
        $0.textColor = .black100
        $0.backgroundColor = .white100
        $0.textContainerInset = UIEdgeInsets(top: 17, left: 17, bottom: 17, right: 17)
        $0.isScrollEnabled = false
        $0.layer.borderColor = UIColor.gray400.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        
        $0.delegate = self
    }
    
    private let placeholderLabel = UILabel().then {
        $0.font = WALFont.body5.font
        $0.textColor = .gray300
        $0.text = "내가 받을 왈소리를 작성해주세요"
    }
    
    private let countLabel = UILabel().then {
        $0.text = "0"
    }
    
    private let maximumCountLabel = UILabel().then {
        $0.text = "/100"
    }
    
    private lazy var hideHistoryButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.title = "도착할 때까지 히스토리에서 가리기"
        config.image = WALIcon.btnUnselect.image
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer {
            var title = $0
            title.foregroundColor = .black100
            title.font = WALFont.body7.font
            return title
        }
        
        $0.configuration = config
        $0.addTarget(self, action: #selector(touchUpHideHistoryButton), for: .touchUpInside)
    }
    
    private lazy var reservationTableView = UITableView(frame: .zero, style: .insetGrouped).then {
        $0.backgroundColor = .white100
        $0.isScrollEnabled = false
        $0.makeRound(radius: 10)
        $0.rowHeight = UITableView.automaticDimension
        $0.tableHeaderView = UIView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: $0.frame.size.width,
                                                  height: CGFloat.leastNonzeroMagnitude))
        $0.dataSource = self
    }
    
    private let toastMessageLabel = UILabel().then {
        $0.text = "이미 왈소리를 보냈어요"
        $0.font = WALKit.WALFont.body8.font
        $0.textColor = .white100
        $0.textAlignment = .center
        $0.backgroundColor = .black100.withAlphaComponent(0.6)
        $0.makeRound(radius: 16.5)
    }
    
    private lazy var sendButton = UIButton().then {
        $0.titleLabel?.font = WALFont.body1.font
        $0.setTitle("보내기", for: .normal)
        $0.setTitleColor(.white100, for: .normal)
        $0.backgroundColor = .gray400
        $0.layer.cornerRadius = 22
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(touchUpSendButton), for: .touchUpInside)
    }
    
    private lazy var countStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 0
        $0.addArrangedSubviews([countLabel, maximumCountLabel])
    }
    
    private var isSelectedHideHistory = false {
        didSet {
            isSelectedHideHistory == false ? hideHistoryButton.setImage(WALIcon.btnUnselect.image, for: .normal) : hideHistoryButton.setImage(WALIcon.btnSelect.image, for: .normal)
        }
    }
    
    private var datePickerType: DatePickerType = .none
    private var datePickerData = DatePickerData()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupLayout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - InitUI
    
    private func configUI() {
        view.backgroundColor = .white100
        navigationController?.navigationBar.isHidden = true
        
        [countLabel, maximumCountLabel].forEach {
            $0.font = WALFont.body8.font
            $0.textColor = .gray200
        }
    }
    
    private func setupLayout() {
        view.addSubviews([navigationBar,
                          scrollView,
                          sendButton])
        
        scrollView.addSubview(createView)
        
        createView.addSubviews([walSoundLabel,
                                showInformationButton,
                                walSoundTextView,
                                placeholderLabel,
                                countStackView,
                                hideHistoryButton,
                                reservationTableView])
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.layoutMarginsGuide)
            $0.leading.equalToSuperview().inset(4)
            $0.trailing.equalToSuperview().inset(9)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalTo(view.layoutMarginsGuide)
            $0.bottom.equalTo(view.layoutMarginsGuide)
        }
        
        createView.snp.makeConstraints {
            $0.top.bottom.equalTo(scrollView)
            $0.leading.trailing.equalTo(view)
            $0.height.equalTo(scrollView.snp.height)
        }
        
        walSoundLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(33)
            $0.leading.equalToSuperview().inset(20)
        }
        
        showInformationButton.snp.makeConstraints {
            $0.centerY.equalTo(walSoundLabel.snp.centerY)
            $0.leading.equalTo(walSoundLabel.snp.trailing)
        }
        
        walSoundTextView.snp.makeConstraints {
            $0.top.equalTo(walSoundLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(161)
        }
        
        placeholderLabel.snp.makeConstraints {
            $0.top.leading.equalTo(walSoundTextView).inset(17)
        }
        
        countStackView.snp.makeConstraints {
            $0.bottom.equalTo(walSoundTextView.snp.bottom).inset(10)
            $0.trailing.equalTo(walSoundTextView.snp.trailing).inset(17)
        }
        
        hideHistoryButton.snp.makeConstraints {
            $0.top.equalTo(walSoundTextView.snp.bottom)
            $0.leading.equalToSuperview()
        }
        
        reservationTableView.snp.makeConstraints {
            $0.top.equalTo(hideHistoryButton.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(0)
            $0.bottom.equalToSuperview()
        }
        
        sendButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.layoutMarginsGuide).inset(11)
            $0.height.equalTo(52)
        }
    }
    
    //MARK: - @objc
    
    @objc private func touchUpHideHistoryButton() {
        isSelectedHideHistory.toggle()
    }
    
    @objc private func touchUpSendButton() {
        let viewController = CreateFinishedViewController()
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy. MM. dd"
        timeFormatter.dateFormat = "a hh:mm"
        
        viewController.date = "\(dateFormatter.string(from: datePickerData.date ?? Date())) \(timeFormatter.string(from: datePickerData.time ?? Date()))"
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func touchUpInformationButton() {
        let viewController = CreateInformationViewController()
        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: false)
    }
    
    //MARK: - CustomMethod
    
    private func setSendButton() {
        let isCotentFull = walSoundTextView.text.count > 0 && datePickerData.date != nil && datePickerData.time != nil
        
        sendButton.backgroundColor = isCotentFull ? .orange100 : .gray400
        sendButton.isEnabled = isCotentFull
    }
    
    private func scroll(_ datePickerType: DatePickerType) {
        switch datePickerType {
        case .date:
            if datePickerData.didShowView.date {
                scrollView.setContentOffset(CGPoint(x: 0, y: 55), animated: true)
            } else {
                scrollView.setContentOffset(.zero, animated: true)
            }
        case .time:
            if datePickerData.didShowView.time {
                scrollView.setContentOffset(CGPoint(x: 0, y: 55), animated: true)
            } else {
                scrollView.setContentOffset(.zero, animated: true)
            }
        case .none: return
        }
    }
    
    private func showToastMessage() {
        let toastLabel = UILabel().then {
            $0.text = "이미 왈소리를 보냈어요"
            $0.font = WALFont.body8.font
            $0.textColor = .white100
            $0.textAlignment = .center
            $0.backgroundColor = .black100.withAlphaComponent(0.6)
            $0.makeRound(radius: 16.5)
        }
        
        view.addSubview(toastLabel)
        
        toastLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(sendButton.snp.top).offset(-16)
            $0.width.equalTo(180)
            $0.height.equalTo(33)
        }
        
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
}

//MARK: - UITextViewDelegate

extension CreateViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        walSoundTextView.layer.borderColor = UIColor.gray400.cgColor
        
        (walSoundTextView.text.count == 0) ? (placeholderLabel.isHidden = false) : (placeholderLabel.isHidden = true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        walSoundTextView.layer.borderColor = UIColor.orange100.cgColor
        placeholderLabel.isHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        countLabel.text = "\(walSoundTextView.text.count)"
        
        countLabel.textColor = walSoundTextView.text.count >= 100 ? .orange100 : .gray200
        
        if walSoundTextView.text.count > 100 {
            walSoundTextView.deleteBackward()
        }
        
        setSendButton()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            walSoundTextView.resignFirstResponder()
            return false
        }
        return true
    }
}

//MARK: - UITableViewDataSource

extension CreateViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if datePickerData.didShowView.date || datePickerData.didShowView.time {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let reservationCell = ReservationTableViewCell()
            
            reservationCell.selectionStyle = .none
            reservationCell.setup(data: datePickerData)
            
            reservationCell.touchedDateButton = {
                self.walSoundTextView.resignFirstResponder()
                self.datePickerData.didShowView.date.toggle()
                self.datePickerData.didShowView.time = false
                self.datePickerType = .date
                self.reservationTableView.reloadSections([indexPath.section], with: .automatic)
                
                self.scroll(.date)
            }
            
            reservationCell.touchedTimeButton = {
                self.walSoundTextView.resignFirstResponder()
                self.datePickerData.didShowView.time.toggle()
                self.datePickerData.didShowView.date = false
                self.datePickerType = .time
                self.reservationTableView.reloadSections([indexPath.section], with: .automatic)
                
                self.scroll(.time)
            }
            
            return reservationCell
        } else {
            let datePickerCell = DatePickerTableViewCell()
            
            datePickerCell.selectionStyle = .none
            datePickerCell.datePickerType = datePickerType
            datePickerCell.setup(date: datePickerData)
            
            datePickerCell.sendDate = { date, didShowToastMessage in
                if didShowToastMessage {
                    self.showToastMessage()
                    self.datePickerData.didShowView.date = true
                } else {
                    self.datePickerData.didShowView.date = false
                    self.datePickerData.didShowView.time = false
                    self.scroll(.date)
                }
                
                switch self.datePickerType {
                case .date: self.datePickerData.date = date
                case .time: self.datePickerData.time = date
                case .none: break
                }
                self.reservationTableView.reloadSections([indexPath.section], with: .automatic)
                self.setSendButton()
            }
            
            return datePickerCell
        }
    }
}
