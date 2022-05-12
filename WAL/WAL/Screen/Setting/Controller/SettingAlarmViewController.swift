//
//  SettingAlarmViewController.swift
//  WAL
//
//  Created by heerucan on 2022/05/08.
//

import UIKit

import WALKit

final class SettingAlarmViewController: UIViewController {
    
    // MARK: - Properties
    
    private let setting = SettingData()
    
    public let navigationBar = WALNavigationBar(title: "알림").then {
        $0.backgroundColor = .white100
        $0.leftIcon = WALIcon.btnBack.image
        $0.leftBarButton.addTarget(self, action: #selector(touchupBackButton), for: .touchUpInside)
    }
    
    private lazy var firstView = AlarmView(.firstMenu)
    
    private lazy var secondView = AlarmView(.secondMenu)
    
    private let backView = UIView().then {
        $0.backgroundColor = .white100
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "왈소리 받는 시간"
        $0.font = WALFont.body6.font
        $0.textColor = .black100
    }
    
    private lazy var collectionView = UICollectionView(
        frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
            $0.backgroundColor = .white100
            $0.showsHorizontalScrollIndicator = false
            $0.isScrollEnabled = false
            $0.isUserInteractionEnabled = true
            $0.allowsMultipleSelection = true
        }
    
    private let collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
    }
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupLayout()
        setupCollectionView()
    }
    
    // MARK: - InitUI
    
    private func configUI() {
        view.backgroundColor = .white100
    }
    
    private func setupLayout() {
        view.addSubviews([navigationBar,
                          firstView,
                          secondView,
                          backView,
                          titleLabel,
                          collectionView])
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(47)
            make.leading.trailing.equalToSuperview()
        }
        
        firstView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        secondView.snp.makeConstraints { make in
            make.top.equalTo(firstView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        backView.snp.makeConstraints { make in
            make.top.equalTo(secondView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backView.snp.bottom).offset(23)
            make.leading.equalToSuperview().inset(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(104)
        }
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SettingAlarmCollectionViewCell.self,
            forCellWithReuseIdentifier: "SettingAlarmCollectionViewCell")
    }
        
    // MARK: - @objc
    
    @objc func touchupBackButton() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource

extension SettingAlarmViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return timeData.getTimeCount()
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SettingAlarmCollectionViewCell",
            for: indexPath) as? SettingAlarmCollectionViewCell
        else { return UICollectionViewCell() }
        cell.setupData(index: indexPath.item)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SettingAlarmViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width-72)/3, height: 104)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}
