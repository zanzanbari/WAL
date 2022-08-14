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
    
    private var joke = false
    private var compliment = false
    private var condolence = false
    private var scolding = false
    
    private var morning = false
    private var launch = false
    private var evening = false
        
    private let navigationBar = WALNavigationBar(title: nil).then {
        $0.backgroundColor = .white100
        $0.leftIcon = WALIcon.btnBack.image
        $0.leftBarButton.addTarget(self, action: #selector(touchupBackButton), for: .touchUpInside)
    }
    
    private let topView = UIView()
    
    private let pageControl = UIImageView().then {
        $0.image = WALIcon.icnProgress1.image
    }
    
    private lazy var collectionView = UICollectionView(
        frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
            $0.backgroundColor = .white100
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
        view.addSubviews([navigationBar, topView, collectionView])
        topView.addSubview(pageControl)
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        topView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(UIScreen.main.hasNotch ? 11 : 4)
            make.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            OnboardingCollectionViewCell.self,
            forCellWithReuseIdentifier: OnboardingCollectionViewCell.identifier)
        collectionView.register(
            CategoryCollectionViewCell.self,
            forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.register(
            AlarmCollectionViewCell.self,
            forCellWithReuseIdentifier: AlarmCollectionViewCell.identifier)
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
    
    @objc func touchupCompleteButton(_ sender: UIButton) {
        let dataType = CategoryType(self.joke, self.compliment, self.condolence, self.scolding)
        let alarmTime = AlarmTime(self.morning, self.launch, self.evening)
        guard let nickname = UserDefaults.standard.string(forKey: Constant.Key.nickname) else { return }
        OnboardAPI.shared.postOnboardSetting(nickname: nickname, dataType: dataType, time: alarmTime) {
            (onboardData, err) in
            guard let onboardData = onboardData else { return }
            if onboardData.status < 400 {
                let viewController = OnboardCompleteViewController()
                self.navigationController?.pushViewController(viewController, animated: true)
                print("☘️--------온보딩 서버 통신 완료", onboardData)
            } else {
                print("☘️--------온보딩 서버 통신 실패로 인해 화면 전환 실패")
            }
        }
    }
}

// MARK: - UICollectionViewDelegate

extension OnboardingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
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
                withReuseIdentifier: OnboardingCollectionViewCell.identifier,
                for: indexPath) as? OnboardingCollectionViewCell
            else { return UICollectionViewCell() }
            cell.nextButton.addTarget(self, action: #selector(scrollToSecond), for: .touchUpInside)
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CategoryCollectionViewCell.identifier,
                for: indexPath) as? CategoryCollectionViewCell
            else { return UICollectionViewCell() }
            cell.nextButton.addTarget(self, action: #selector(scrollToThird), for: .touchUpInside)
            navigationBar.leftBarButton.addTarget(self, action: #selector(touchupBackButton), for: .touchUpInside)
            cell.sendCategoryDelegate = self
            return cell
            
        case 2:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AlarmCollectionViewCell.identifier,
                for: indexPath) as? AlarmCollectionViewCell
            else { return UICollectionViewCell() }
            navigationBar.leftBarButton.addTarget(self, action: #selector(touchupBackButton), for: .touchUpInside)
            cell.completeButton.addTarget(self, action: #selector(touchupCompleteButton(_:)), for: .touchUpInside)
            cell.sendAlarmTimeDelegate = self
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: view.frame.size.width,
            height: view.frame.size.height - navigationBar.frame.size.height -
            topView.frame.size.height - (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0))
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

// MARK: - Delegate

extension OnboardingViewController: SendCategoryDelegate, SendAlarmTimeDelegate {
    func sendCategory(joke: Bool, compliment: Bool, condolence: Bool, scolding: Bool) {
        self.joke = joke
        self.compliment = compliment
        self.condolence = condolence
        self.scolding = scolding
    }
    
    func sendAlarmTime(morning: Bool, launch: Bool, evening: Bool) {
        self.morning = morning
        self.launch = launch
        self.evening = evening
    }
}
