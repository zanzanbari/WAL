//
//  OnboardingViewController.swift
//  WAL
//
//  Created by heerucan on 2022/04/30.
//

import UIKit

import Then
import WALKit

final class OnboardingViewController: UIViewController {
    
    // MARK: - Properties
    
    private var currentRow: Int = 0
    private var didCurrentRow: Int = 0
    
    private let navigationBar = WALNavigationBar(title: nil).then {
        $0.leftIcon = WALIcon.btnBack.image
        $0.leftBarButton.addTarget(self, action: #selector(touchupBackButton), for: .touchUpInside)
    }
    
    private lazy var progressView = UIView().then {
        $0.backgroundColor = .white100
        $0.addSubviews([navigationBar, pageControl])
    }
    
    private let pageControl = UIImageView().then {
        $0.image = WALIcon.icnProgress1.image
    }
    
    private lazy var collectionView = UICollectionView(
        frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
            $0.backgroundColor = .white
            $0.allowsSelection = true
            $0.contentInsetAdjustmentBehavior = .never
            $0.showsHorizontalScrollIndicator = false
            $0.isScrollEnabled = false
            $0.isUserInteractionEnabled = true
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
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - InitUI
    
    private func configUI() {
        view.backgroundColor = .white100
    }
    
    private func setupLayout() {
        view.addSubviews([progressView, collectionView])
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(47)
            make.leading.trailing.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(102)
            make.centerX.equalToSuperview()
        }
        
        progressView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(121)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(OnboardingCollectionViewCell.self,
                                forCellWithReuseIdentifier: "OnboardingCollectionViewCell")
        collectionView.register(CategoryCollectionViewCell.self,
                                forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        collectionView.register(AlarmCollectionViewCell.self,
                                forCellWithReuseIdentifier: "AlarmCollectionViewCell")
    }
    
    // MARK: - @objc
    
    @objc func touchupBackButton() {
        if currentRow == 1 {
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .right, animated: true)
        } else if currentRow == 2 {
            collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .right, animated: true)
        }
    }
    
    @objc func scrollToSecond() {
        collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .left, animated: true)
    }
    
    @objc func scrollToThird() {
        collectionView.scrollToItem(at: IndexPath(row: 2, section: 0), at: .left, animated: true)
    }
}

// MARK: - UICollectionViewDelegate

extension OnboardingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        currentRow = indexPath.row
        if currentRow == 0 {
            navigationBar.isHidden = true
            pageControl.image = WALIcon.icnProgress1.image
        } else if currentRow == 1 {
            navigationBar.isHidden = false
            pageControl.image = WALIcon.icnProgress2.image
            dismissKeyboard()
        } else if currentRow == 2 {
            pageControl.image = WALIcon.icnProgress3.image
            navigationBar.isHidden = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 2:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "AlarmCollectionViewCell",
                for: indexPath) as? AlarmCollectionViewCell
            else { return }
            guard let timeCell = cell.collectionView.dequeueReusableCell(withReuseIdentifier: "TimeButtonCollectionViewCell", for: indexPath) as? TimeButtonCollectionViewCell else { return }
            if timeCell.isSelected == false {
                print("안선택")
            }
            
            if timeCell.timeButton.isSelected {
                print("버튼")
            }
//            navigationBar.leftBarButton.addTarget(self, action: #selector(touchupBackButton), for: .touchUpInside)
            
        default: break
        }
    }
}

// MARK: - UICollectionViewDataSource

extension OnboardingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "OnboardingCollectionViewCell",
                for: indexPath) as? OnboardingCollectionViewCell
            else { return UICollectionViewCell() }
            cell.nextButton.addTarget(self, action: #selector(scrollToSecond), for: .touchUpInside)
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "CategoryCollectionViewCell",
                for: indexPath) as? CategoryCollectionViewCell
            else { return UICollectionViewCell() }
            cell.nextButton.addTarget(self, action: #selector(scrollToThird), for: .touchUpInside)
            navigationBar.leftBarButton.addTarget(self, action: #selector(touchupBackButton), for: .touchUpInside)
            return cell
            
        case 2:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "AlarmCollectionViewCell",
                for: indexPath) as? AlarmCollectionViewCell
            else { return UICollectionViewCell() }
            guard let timeCell = cell.collectionView.dequeueReusableCell(withReuseIdentifier: "TimeButtonCollectionViewCell", for: indexPath) as? TimeButtonCollectionViewCell else { return UICollectionViewCell() }
            
            navigationBar.leftBarButton.addTarget(self, action: #selector(touchupBackButton), for: .touchUpInside)
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: view.frame.size.height-121)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}
