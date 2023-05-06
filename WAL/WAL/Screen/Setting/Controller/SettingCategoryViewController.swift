//
//  SettingCategoryViewController.swift
//  WAL
//
//  Created by heerucan on 2022/06/27.
//

import UIKit

import WALKit

final class SettingCategoryViewController: UIViewController {
    
    // MARK: - Properties
        
    private lazy var categoryButtons = [comedyButton, fussButton, comfortButton, yellButton]
    
    private let setting = SettingData()
    
    private lazy var navigationBar = WALNavigationBar(title: Constant.NavigationTitle.settingCategory).then {
        $0.backgroundColor = .white100
        $0.leftIcon = WALIcon.btnBack.image
        $0.leftBarButton.addTarget(self, action: #selector(touchupBackButton), for: .touchUpInside)
    }
    
    private let titleLabel = UILabel().then {
        $0.text = Constant.SettingCategory.title
        $0.font = WALFont.body6.font
        $0.textColor = .black100
    }
    
    private let subtitleLabel = UILabel().then {
        $0.text = Constant.SettingCategory.subtitle
        $0.font = WALFont.body9.font
        $0.textColor = .gray100
    }
    
    private let loadingView = LoadingView()
    
    private lazy var firstCategoryStackView = UIStackView()
    private lazy var secondCategoryStackView = UIStackView()
    
    private let comedyButton = CategoryButton(0)
    private let fussButton = CategoryButton(1)
    private let comfortButton = CategoryButton(2)
    private let yellButton = CategoryButton(3)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCategory()
        configUI()
        setupLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    // MARK: - InitUI
    
    private func configUI() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        view.backgroundColor = .white100
        [firstCategoryStackView, secondCategoryStackView].forEach {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fillEqually
            $0.spacing = 9
        }
        
        categoryButtons.forEach {
            $0.addTarget(self, action: #selector(touchupButton(_:)), for: .touchUpInside)
        }
    }
    
    private func setupLayout() {
        view.addSubviews([navigationBar, titleLabel, subtitleLabel, firstCategoryStackView, secondCategoryStackView])
        firstCategoryStackView.addArrangedSubviews([comedyButton, fussButton])
        secondCategoryStackView.addArrangedSubviews([comfortButton, yellButton])
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(7)
            make.leading.equalToSuperview().inset(20)
        }
        
        firstCategoryStackView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(163)
        }
        
        secondCategoryStackView.snp.makeConstraints { make in
            make.top.equalTo(firstCategoryStackView.snp.bottom).offset(9)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(163)
        }
        
        categoryButtons.forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(163)
            }
        }
    }
    
    // MARK: - Custom Method
    
    private func configureLoadingView() {
        let loadingView = LoadingView()
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        loadingView.play()
    }
    
    private func showToastMessage() {
        let selectedButtons = categoryButtons.filter { $0.isSelected }
        if selectedButtons.count < 1 {
            showToast(message: Constant.Toast.selectOneMore)
        }
    }
    
    // MARK: - @objc
    
    @objc func touchupBackButton() {
        postCategory()
    }
    
    @objc func touchupButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        showToastMessage()
    }
}

// MARK: - Network

extension SettingCategoryViewController {
    private func updateButtonStates(data: [String]) {
        for (button, type) in zip(categoryButtons, WalCategoryType.allCases) {
            button.isSelected = data.contains(type.rawValue) ? true : false
        }
    }
    
    private func getCategory() {
        SettingAPI.shared.getCategory { [weak self] (data, status) in
            guard let self = self else { return }
            guard let data = data?.categoryInfo else { return }
            self.updateButtonStates(data: data)
        }
    }
    
    private func postCategory() {
        let selectedButtons = categoryButtons.filter { $0.isSelected }
        let data = selectedButtons.map { $0.data.getCategory(index: $0.tag) }
        
        SettingAPI.shared.postCategory(data: data) { [weak self] (data, status) in
            guard let self = self else { return }
            guard let status = status else { return }
            if status == 204 {
                self.configureLoadingView()
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    self.loadingView.hide()
                    self.transition(self, .pop)
                }
                
                // TODO: - 수정 전 값과 같으면 로티 X
            }
        }
    }
}
