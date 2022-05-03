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
    
    private lazy var progressView = UIView().then {
        $0.backgroundColor = .white100
        $0.addSubview(pageControl)
    }
    
    private let pageControl = UIImageView().then {
        $0.image = WALIcon.icnProgress1.image
    }
    
    private lazy var collectionView = UICollectionView(
        frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
            $0.backgroundColor = .white
            $0.allowsSelection = false
            $0.contentInsetAdjustmentBehavior = .never
            $0.showsHorizontalScrollIndicator = false
            $0.isScrollEnabled = false
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
    
    @objc func scrollToSecond() {
        collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .left, animated: true)
    }
    
    @objc func scrollToThird() {
        collectionView.scrollToItem(at: IndexPath(row: 2, section: 0), at: .left, animated: true)
        pageControl.image = WALIcon.icnProgress3.image
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell",
                for: indexPath) as? OnboardingCollectionViewCell
            else { return UICollectionViewCell() }
            cell.nextButton.addTarget(self, action: #selector(scrollToSecond), for: .touchUpInside)
            pageControl.image = WALIcon.icnProgress1.image
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell",
                for: indexPath) as? CategoryCollectionViewCell
            else { return UICollectionViewCell() }
            cell.nextButton.addTarget(self, action: #selector(scrollToThird), for: .touchUpInside)
            pageControl.image = WALIcon.icnProgress2.image
            return cell
            
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlarmCollectionViewCell",
                for: indexPath) as? AlarmCollectionViewCell
            else { return UICollectionViewCell() }
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
