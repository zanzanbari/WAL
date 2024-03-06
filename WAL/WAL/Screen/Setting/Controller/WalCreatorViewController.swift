//
//  WalCreatorViewController.swift
//  WAL
//
//  Created by 소연 on 2023/09/05.
//

import UIKit

import RxCocoa
import RxSwift
import Then
import WALKit

final class WalCreatorViewController: UIViewController {
    
    // MARK: - UI Property
    
    private lazy var navigationBar = WALNavigationBar(title: "왈소리 크리에이터").then {
        $0.backgroundColor = .white100
        $0.leftIcon = WALIcon.btnBack.image
    }
    
    private lazy var navigationBackView = UIView().then {
        $0.backgroundColor = .white100
    }
    
    /*
     상단 설명 화면
     - 왈뿡이 이미지
     - 타이틀
     - 서브타이틀
     */
    private lazy var guideBackView = UIView().then {
        $0.backgroundColor = .white100
    }
    
    private lazy var guideImageView = UIImageView().then {
        $0.image = WALIcon.icnCreate.image
        $0.contentMode = .scaleToFill
    }
    
    private lazy var guideTitleLabel = UILabel().then {
        $0.textColor = .black100
        $0.font = WALFont.title05.font
        $0.text = """
                  당신의 왈소리를
                  세상에 뽐내보세요
                  """
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private lazy var guideSubtitleLabel = UILabel().then {
        $0.textColor = .black100
        $0.font = WALFont.body9.font
        $0.text = """
                  하지만 주의하세요, 이 왈소리는 언제, 누구에게 도착할지
                  아무도 몰라요! 그때까지 긴장을 늦추지 마세요.
                  """
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    /*
     하단 인풋 화면
     - 왈소리 유형
     - 왈소리 작성
     */
    private lazy var walInputBackView = UIView().then {
        $0.backgroundColor = .gray600
    }
    
    private lazy var walTypeTitleLabel = UILabel().then {
        $0.textColor = .black100
        $0.font = WALFont.body4.font
        $0.text = "내가 뽐낼 왈소리는 어떤 유형인가요?"
    }
    
    private lazy var walTypeTextField = WALTextField().then {
        $0.placeholder = "드립"
    }
    
    private lazy var walTextTitleLabel = UILabel().then {
        $0.textColor = .black100
        $0.font = WALFont.body4.font
        $0.text = "왈소리를 뽐내주세요"
    }
    
    private lazy var walTextView = UITextView().then {
        $0.font = WALFont.body5.font
        $0.textColor = .black100
        $0.backgroundColor = .white100
        $0.textContainerInset = UIEdgeInsets(top: 14, left: 16, bottom: 16, right: 16)
        $0.isScrollEnabled = false
        $0.layer.borderColor = UIColor.gray400.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.delegate = self
        $0.tintColor = .orange100
    }
    
    private lazy var placeholderLabel = UILabel().then {
        $0.textColor = .gray300
        $0.font = WALFont.body5.font
        $0.text = "내가 받을 왈소리를 작성해주세요"
    }
    
    private lazy var countLabel = UILabel().then {
        $0.textColor = .gray200
        $0.font = WALFont.body8.font
        $0.text = "0"
    }
    
    private lazy var maximumCountLabel = UILabel().then {
        $0.textColor = .gray200
        $0.font = WALFont.body8.font
        $0.text = "/50"
    }
    
    private lazy var countStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 0
        $0.addArrangedSubviews([countLabel, maximumCountLabel])
    }
    
    private lazy var sendButton = WALPlainButton().then {
        $0.title = "보내기"
        $0.isDisabled = true
    }
    
    // 로딩 뷰
    private let loadingView = LoadingView().then {
        $0.alpha = 0
    }
    
    private lazy var walTypePickerView = UIPickerView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.autoresizingMask = .flexibleWidth
        $0.backgroundColor = .gray500
    }
    
    // MARK: - Property
    
    private var walType: [WalCategoryType] = [.comedy, .fuss, .comfort, .yell]
    private var selectedWalType: WalCategoryType = .comedy
    
    private let viewModel = WalCreatorViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        setupLayout()
        setTextField()
        setToolbar()
        
        rxBindOutput()
        rxBindView()
    }
    
    // MARK: - Init UI
    
    private func configUI() {
        view.backgroundColor = .gray600
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        walTextView.returnKeyType = .done
        
        guideTitleLabel.addLineSpacing(spacing: 0.4)
        guideTitleLabel.addLetterSpacing()
        guideSubtitleLabel.addLineSpacing(spacing: 0.4)
        guideSubtitleLabel.addLetterSpacing()
    }
    
    private func setupLayout() {
        view.addSubviews([guideBackView,
                          navigationBackView,
                          navigationBar,
                          walInputBackView,
                          sendButton])
        
        guideBackView.snp.makeConstraints {
            $0.bottom.equalTo(walInputBackView.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(389)
        }
        navigationBackView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(91)
        }
        navigationBar.snp.makeConstraints {
            $0.top.trailing.equalTo(view.layoutMarginsGuide)
            $0.leading.equalToSuperview().inset(4)
        }
        walInputBackView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(298)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(sendButton.snp.top)
        }
        sendButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(Layouts.horizontalMargin)
        }
        
        setupGuideViewLayout()
        setupInputViewLayout()
        
        NSLayoutConstraint.activate([
            view.keyboardLayoutGuide.topAnchor.constraint(
                equalTo: sendButton.bottomAnchor,
                constant: 16
            )
        ])
    }
    
    /// 왈소리 크리에이터 Guide UI Layout
    private func setupGuideViewLayout() {
        guideBackView.addSubviews([guideImageView,
                                   guideTitleLabel,
                                   guideSubtitleLabel])
        
        guideImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(110)
            $0.width.equalTo(188)
            $0.height.equalTo(122)
            $0.centerX.equalToSuperview()
        }
        
        guideTitleLabel.snp.makeConstraints {
            $0.top.equalTo(guideImageView.snp.bottom).offset(19)
            $0.centerX.equalToSuperview()
        }
        
        guideSubtitleLabel.snp.makeConstraints {
            $0.top.equalTo(guideTitleLabel.snp.bottom).offset(11)
            $0.horizontalEdges.equalToSuperview().inset(Layouts.horizontalMargin)
        }
    }
    
    /// 왈소리 유형/컨텐츠 입력 UI Layout 
    private func setupInputViewLayout() {
        walInputBackView.addSubviews([walTypeTitleLabel,
                                      walTypeTextField,
                                      walTextTitleLabel,
                                      walTextView,
                                      countStackView])
        
        walTypeTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(26)
            $0.leading.equalToSuperview().inset(Layouts.horizontalMargin)
        }
        walTypeTextField.snp.makeConstraints {
            $0.top.equalTo(walTypeTitleLabel.snp.bottom).offset(17)
            $0.horizontalEdges.equalToSuperview().inset(Layouts.horizontalMargin)
        }
        walTextTitleLabel.snp.makeConstraints {
            $0.top.equalTo(walTypeTextField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(Layouts.horizontalMargin)
        }
        walTextView.snp.makeConstraints {
            $0.top.equalTo(walTextTitleLabel.snp.bottom).offset(17)
            $0.horizontalEdges.equalToSuperview().inset(Layouts.horizontalMargin)
            $0.height.equalTo(99)
        }
        countStackView.snp.makeConstraints {
            $0.bottom.equalTo(walTextView.snp.bottom).inset(10)
            $0.trailing.equalTo(walTextView.snp.trailing).inset(17)
        }
    }
    
    // MARK: - RxBind
    
    private func rxBindOutput() {
        viewModel.output.wal
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, result in
                switch result {
                case .created:
                    owner.navigationController?.popViewController(animated: true)
                default:
                    owner.navigationController?.popViewController(animated: true)
                    return
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func rxBindView() {
        navigationBar.leftBarButton
            .rx
            .tap
            .preventDuplication()
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        sendButton
            .rx
            .tap
            .preventDuplication()
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, _ in
                owner.viewModel.input.postWal.accept((owner.selectedWalType, owner.walTextView.text))
            }
            .disposed(by: disposeBag)
    }
    
    private func rxBindInput() {
        
    }
    
    // MARK: - Custom Method
    
    private func configLoadingView() {
        let loadingView = LoadingView()
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        loadingView.play()
    }
    
    private func setSendButton() {
        let isCotentFull = walTextView.text.count > 0
        
        sendButton.backgroundColor = isCotentFull ? .orange100 : .gray400
        sendButton.isEnabled = isCotentFull
    }
    
    private func setTextField() {
        walTypeTextField.delegate = self
        
        walTypeTextField.tintColor = .clear
        walTypeTextField.inputView = walTypePickerView
        walTypeTextField.text = WalCategoryType.comedy.kor
    }
    
    private func setToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.tintColor = .orange100
        
        let button = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(touchUpDoneButton))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, button], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        walTypeTextField.inputAccessoryView = toolBar
    }
    
    private func keyboardUp() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.walInputBackView.snp.remakeConstraints {
                $0.top.equalTo(self.navigationBar.snp.bottom)
                $0.horizontalEdges.equalToSuperview()
                $0.bottom.equalTo(self.sendButton.snp.top)
            }
            
            self.walInputBackView.superview?.layoutIfNeeded()
        })
    }
    
    private func keyboardDown() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.walInputBackView.snp.remakeConstraints {
                $0.top.equalTo(self.navigationBar.snp.bottom).offset(298)
                $0.horizontalEdges.equalToSuperview()
                $0.bottom.equalTo(self.sendButton.snp.top)
            }
            self.walInputBackView.superview?.layoutIfNeeded()
        })
    }
    
    // MARK: - @objc
    
    @objc func touchUpDoneButton() {
        self.view.endEditing(true)
        keyboardDown()
        walTypeTextField.layer.borderColor = UIColor.gray400.cgColor
    }
    
}

// MARK: - Layouts {

extension WalCreatorViewController {
    
    enum Layouts {
        /// 좌/우
        static let horizontalMargin = 20
    }
    
}

// MARK: - UITextField Delegate

extension WalCreatorViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyboardUp()
        walTypeTextField.layer.borderColor = UIColor.orange100.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        keyboardDown()
        walTypeTextField.layer.borderColor = UIColor.gray400.cgColor
    }
    
}

// MARK: - UITextView Delegate

extension WalCreatorViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        walTextView.layer.borderColor = UIColor.gray400.cgColor
        
        (walTextView.text.count == 0) ? (placeholderLabel.isHidden = false) : (placeholderLabel.isHidden = true)
        
        keyboardDown()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        walTextView.layer.borderColor = UIColor.orange100.cgColor
        placeholderLabel.isHidden = true
        
        keyboardUp()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        countLabel.text = "\(walTextView.text.count)"
        
        countLabel.textColor = walTextView.text.count >= 50 ? .orange100 : .gray200
        
        if walTextView.text.count > 50 {
            walTextView.deleteBackward()
        }
        
        setSendButton()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            walTextView.resignFirstResponder()
            return false
        }
        return true
    }
    
}

// MARK: - UIPickerView Delegate

extension WalCreatorViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return walType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        
        label.textAlignment = .center
        
        if pickerView.selectedRow(inComponent: component) == row {
            label.attributedText = NSAttributedString(string: walType[row].kor,
                                                      attributes: [NSAttributedString.Key.font: WALFont.body2.font,
                                                                   NSAttributedString.Key.foregroundColor: UIColor.orange100])
            selectedWalType = walType[row]
        } else {
            label.attributedText = NSAttributedString(string: walType[row].kor,
                                                      attributes: [NSAttributedString.Key.font: WALFont.body2.font,
                                                                   NSAttributedString.Key.foregroundColor: UIColor.gray100])
        }
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 200
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        walTypeTextField.text = walType[row].kor
        pickerView.reloadAllComponents()
    }
    
}
