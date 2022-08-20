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
    
    private let setting = SettingData()
    
    private let navigationBar = WALNavigationBar(title: "왈소리 유형").then {
        $0.backgroundColor = .white100
        $0.leftIcon = WALIcon.btnBack.image
        $0.leftBarButton.addTarget(self, action: #selector(touchupBackButton), for: .touchUpInside)
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "받고 싶은 왈소리 유형을 선택해주세요"
        $0.font = WALFont.body6.font
        $0.textColor = .black100
    }
    
    private let subtitleLabel = UILabel().then {
        $0.text = "다중 선택 가능해요"
        $0.font = WALFont.body9.font
        $0.textColor = .gray100
    }
    
    private lazy var firstCategoryStackView = UIStackView()
    private lazy var secondCategoryStackView = UIStackView()
    
    private let jokeButton = CategoryButton(0)
    private let complimentButton = CategoryButton(1)
    private let condolenceButton = CategoryButton(2)
    private let scoldingButton = CategoryButton(3)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestCategory()
        configUI()
        setupLayout()
    }
    
    // MARK: - InitUI
    
    private func configUI() {
        view.backgroundColor = .white100
        [firstCategoryStackView, secondCategoryStackView].forEach {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fillEqually
            $0.spacing = 9
        }
        
        [jokeButton,
         complimentButton,
         condolenceButton,
         scoldingButton].forEach {
            $0.addTarget(self, action: #selector(touchupButton(sender:)), for: .touchUpInside)
        }
    }
    
    private func setupLayout() {
        view.addSubviews([navigationBar,
                          titleLabel,
                          subtitleLabel,
                          firstCategoryStackView,
                          secondCategoryStackView])
        
        firstCategoryStackView.addArrangedSubviews([jokeButton, complimentButton])
        secondCategoryStackView.addArrangedSubviews([condolenceButton, scoldingButton])
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(47)
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
            make.top.equalTo(subtitleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(163)
        }
        
        secondCategoryStackView.snp.makeConstraints { make in
            make.top.equalTo(firstCategoryStackView.snp.bottom).offset(9)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(163)
        }
        
        [jokeButton, complimentButton, condolenceButton, scoldingButton].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(163)
            }
        }
    }
    
    // MARK: - @objc
    
    @objc func touchupBackButton() {
        if jokeButton.layer.borderColor == UIColor.gray400.cgColor &&
            complimentButton.layer.borderColor == UIColor.gray400.cgColor &&
            condolenceButton.layer.borderColor == UIColor.gray400.cgColor &&
            scoldingButton.layer.borderColor == UIColor.gray400.cgColor {
            showToast(message: "1개 이상 선택해주세요")
        } else {
            postCategory()
        }
    }
    
    @objc func touchupButton(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.layer.borderColor = sender.isSelected ?
        UIColor.orange100.cgColor : UIColor.gray400.cgColor
    }
}

// MARK: - Network

extension SettingCategoryViewController {
    private func buttonBorderColor(_ button: UIButton, _ userCategoryData: Bool) {
        button.isSelected = userCategoryData
        button.layer.borderColor = button.isSelected ?
        UIColor.orange100.cgColor : UIColor.gray400.cgColor
    }
    
    private func requestCategory() {
        SettingAPI.shared.getUserCategory { (userCategoryData, nil) in
            guard let userCategory = userCategoryData?.data else { return }
            print("🌈 카테고리 가져오기 서버통신 🌈", userCategory)
            self.buttonBorderColor(self.jokeButton, userCategory.joke)
            self.buttonBorderColor(self.complimentButton, userCategory.compliment)
            self.buttonBorderColor(self.condolenceButton, userCategory.condolence)
            self.buttonBorderColor(self.scoldingButton, userCategory.scolding)
            self.categoryBeforeChange = CategoryType(
                userCategory.joke,
                userCategory.compliment,
                userCategory.condolence,
                userCategory.scolding)
        }
    }
    
    private func postCategory() {
        SettingAPI.shared.postUserCategory(data: [
            categoryBeforeChange,
            CategoryType(self.jokeButton.isSelected,
                         self.complimentButton.isSelected,
                         self.condolenceButton.isSelected,
                         self.scoldingButton.isSelected)]) { (userCategory, nil) in
                             guard let userCategory = userCategory,
                                   let userCategoryData = userCategory.data else { return }
                             if userCategory.status < 400 {
                                 print("🌈 카테고리 수정 서버 통신 🌈", userCategoryData)
                                 self.jokeButton.isSelected = userCategoryData.joke
                                 self.complimentButton.isSelected = userCategoryData.compliment
                                 self.condolenceButton.isSelected = userCategoryData.condolence
                                 self.scoldingButton.isSelected = userCategoryData.scolding
                                 self.dismiss(animated: true, completion: nil)
                             } else {
                                 print("🌈 카테고리 수정 서버 통신 실패로 화면전환 실패")
                             }
                         }
    }
}