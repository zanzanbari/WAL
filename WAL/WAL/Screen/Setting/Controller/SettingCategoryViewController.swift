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
    
    private var categoryBeforeChange = CategoryType.init(false, false, false, false)
    
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
        requestCategory()
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
        let selectedButtons = categoryButtons.filter {
            $0.layer.borderColor == UIColor.orange100.cgColor
        }
        if selectedButtons.count < 1 {
            showToast(message: Constant.Toast.selectOneMore)
        }
    }
    
    // MARK: - @objc
    
    @objc func touchupBackButton() {
        if comedyButton.layer.borderColor == UIColor.gray400.cgColor &&
            fussButton.layer.borderColor == UIColor.gray400.cgColor &&
            comfortButton.layer.borderColor == UIColor.gray400.cgColor &&
            yellButton.layer.borderColor == UIColor.gray400.cgColor {
            //            showToast(message: "1개 이상 선택해주세요")
        } else {
            postCategory()
        }
    }
    
    @objc func touchupButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.layer.borderColor = sender.isSelected ?
        UIColor.orange100.cgColor : UIColor.gray400.cgColor
        showToastMessage()
    }
}

// MARK: - Network

extension SettingCategoryViewController {
    private func updateButtonStates(data: [String]) {
        for (button, type) in zip(categoryButtons, WalCategoryType.allCases) {
            button.layer.borderColor = data.contains(type.rawValue)
            ? UIColor.orange100.cgColor : UIColor.gray400.cgColor
        }
    }
    
    private func requestCategory() {
        SettingAPI.shared.getCategory { [weak self] (data, status) in
            guard let self = self else { return }
            guard let data = data?.categoryInfo else { return }
            print("🌈 카테고리 가져오기 서버통신 🌈", data)
            self.updateButtonStates(data: data)
//            self.categoryBeforeChange = CategoryType(
//                userCategory.joke, userCategory.compliment, userCategory.scolding, userCategory.condolence)
        }
    }
    
    private func postCategory() {
//        SettingAPI.shared.postUserCategory(data: [
//            categoryBeforeChange,
//            CategoryType(jokeButton.isSelected, complimentButton.isSelected,
//                         scoldingButton.isSelected, condolenceButton.isSelected)]) { [weak self] (data, status) in
//                             guard let self = self else { return }
//                             guard let data = data,
//                                   let userCategoryData = data.categoryInfo else { return }
//                             if userCategory.status < 400 {
//                                 print("🌈 카테고리 수정 서버 통신 🌈", userCategoryData)
//                                 self.jokeButton.isSelected = userCategoryData.joke
//                                 self.complimentButton.isSelected = userCategoryData.compliment
//                                 self.condolenceButton.isSelected = userCategoryData.condolence
//                                 self.scoldingButton.isSelected = userCategoryData.scolding
//                                 if self.categoryBeforeChange.joke == self.jokeButton.isSelected &&
//                                        self.categoryBeforeChange.compliment == self.complimentButton.isSelected &&
//                                        self.categoryBeforeChange.condolence == self.condolenceButton.isSelected &&
//                                        self.categoryBeforeChange.scolding == self.scoldingButton.isSelected {
//                                     self.transition(self, .pop)
//                                 } else {
//                                     self.configureLoadingView()
//                                     DispatchQueue.main.asyncAfter(deadline: .now()+1) {
//                                         self.loadingView.hide()
//                                         self.transition(self, .pop)
//                                     }
//                                 }
//                             } else {
//                                 print("🌈 카테고리 수정 서버 통신 실패로 화면전환 실패")
//                             }
//                         }
    }
}
