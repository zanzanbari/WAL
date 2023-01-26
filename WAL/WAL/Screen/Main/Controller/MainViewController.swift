//
//  MainViewController.swift
//  WAL
//
//  Created by Thisisme Hi on 2022/04/01.
//

import UIKit

import RxCocoa
import RxSwift
import Then
import WALKit

final class MainViewController: UIViewController {

    // MARK: - UI Property
    
    private lazy var navigationBar = UIView().then {
        $0.backgroundColor = .white
        $0.addSubviews([addButton, settingButton])
    }
    
    private lazy var addButton = UIButton().then {
        $0.setImage(WALIcon.btnPlus.image, for: .normal)
    }
    
    private lazy var settingButton = UIButton().then {
        $0.setImage(WALIcon.btnSetting.image, for: .normal)
    }
    
    private var titleView = MainTitleView()
    
    private var walImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    private var contentLabel = UILabel().then {
        $0.font = WALFont.body7.font
        $0.textColor = .gray100
        $0.numberOfLines = 0
        $0.isHidden = false
        $0.textAlignment = .center
    }
    
    private var walCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = .zero
        
        return UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            $0.backgroundColor = .clear
            $0.isScrollEnabled = false
        }
    }()
    
    private var walContentView = MainContentView().then {
        $0.isHidden = true
    }
    
    private lazy var shareButton = UIButton(type: .custom).then {
        $0.setTitle("공유", for: .normal)
        $0.setTitleColor(.white100, for: .normal)
        $0.setTitleColor(.gray500, for: .highlighted)
        $0.backgroundColor = .mint100
        $0.titleLabel?.font = WALFont.body4.font
        $0.layer.cornerRadius = 20
        $0.isHidden = true
    }
    
    // MARK: - Property
    
    private let date = Date()
    private let dateFormatter = DateFormatter().then {
        $0.locale = Locale(identifier: "ko_kr")
        $0.timeZone = TimeZone(abbreviation: "ko_kr")
        $0.dateFormat = "HH"
    }
    
    private var walStatus: WALStatus = .arrived {
        didSet {
            walImageView.image = walStatus.walImage

            contentLabel.text = walStatus.content
            contentLabel.addLetterSpacing()
            
            switch walStatus {
            case .sleeping:
                walCollectionView.isHidden = true
            case .arrived, .checkedAvailable, .checkedAll:
                walCollectionView.isHidden = false
            }
        }
    }
    
    private var didTapCell: Bool = false {
        didSet {
            if didTapCell {
                [titleView, walImageView, contentLabel].forEach {
                    $0.isHidden = true
                }
                
                [walContentView, shareButton].forEach {
                    $0.isHidden = false
                }
                
            } else {
                [titleView, walImageView, contentLabel].forEach {
                    $0.isHidden = false
                }
                
                [walContentView, shareButton].forEach {
                    $0.isHidden = true
                }
            }
        }
    }
    
    private var dataCount: Int = 0
    private var mainData = MainResponse(subtitle: "", todayWal: [])
    
    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configNavigationUI()
        setMainStatus()
        getMainInfo()
        NotificationCenter.default.addObserver(self, selector: #selector(getNotification), name: NSNotification.Name.enterMain, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupLayout()
        bind()
    }
    
    // MARK: - Init UI
    
    private func configNavigationUI() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func configUI() {
        view.backgroundColor = .white100
        
        setupCollectionView()
    }
    
    private func setupLayout() {
        view.addSubviews([titleView,
                          navigationBar,
                          walImageView,
                          contentLabel,
                          walCollectionView,
                          walContentView,
                          shareButton])
        
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        addButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(51)
            $0.width.height.equalTo(44)
        }
        
        settingButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(7)
            $0.width.height.equalTo(44)
        }
        
        titleView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(10)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(54)
            $0.horizontalEdges.equalToSuperview()
        }
        
        walImageView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(UIScreen().hasNotch ? 124 : 97)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(300)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(walImageView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(313)
        }
        
        walCollectionView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(UIScreen().hasNotch ? 16 : 26)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(73)
        }
        
        walContentView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(UIScreen().hasNotch ? 93 : 43)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(21)
            $0.height.equalTo(336)
        }
        
        shareButton.snp.makeConstraints {
            $0.top.equalTo(walContentView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(97)
            $0.height.equalTo(40)
        }
    }
    
    // MARK: - Bind
    
    private func bind() {
        shareButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                let imageToShare = vc.walContentView.toImage()

                let activityItems : NSMutableArray = []
                activityItems.add(imageToShare)

                guard let url = vc.viewModel.saveImageOnPhone(image: imageToShare, image_name: "왈") else { return }
                
                let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                activityViewController.excludedActivityTypes = [UIActivity.ActivityType.addToReadingList]
                
                vc.present(activityViewController, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                guard let self = self else { return }
                let viewController = CreateViewController()
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            .disposed(by: disposeBag)
        
        settingButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                guard let self = self else { return }
                let viewController = SettingViewController()
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Custom Method
    
    private func setupCollectionView() {
        walCollectionView.delegate = self
        walCollectionView.dataSource = self
        
        walCollectionView.register(MainItemCell.self, forCellWithReuseIdentifier: MainItemCell.cellIdentifier)
    }
    
    private func setMainStatus() {
        if titleView.isHidden == true {
            [titleView, walImageView, contentLabel].forEach {
                $0.isHidden = false
            }
            
            [walContentView, shareButton].forEach {
                $0.isHidden = true
            }
        }
    }
    
    // MARK: - @objc
    
    @objc func didTap() {
        self.didTapCell.toggle()
    }
    
    @objc func getNotification() {
        setMainStatus()
        getMainInfo()
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = CGFloat(77)
        let cellHeight = collectionView.frame.height
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MainItemCell else { return true }
        
        if cell.isSelected {
            didTapCell = false
            collectionView.deselectItem(at: indexPath, animated: false)
            return false
        } else {
            didTapCell = true
            walContentView.content = mainData.todayWal[indexPath.item].content
            
            let walType = mainData.todayWal[indexPath.item].categoryID
            walContentView.walContentType = WALContentType(rawValue: walType) ?? .fun
            return true
        }
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataCount
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateMainData(item: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainItemCell.cellIdentifier, for: indexPath) as? MainItemCell else { return UICollectionViewCell() }
        cell.setupData(mainData.todayWal[indexPath.item])
        
        if mainData.todayWal[indexPath.item].canOpen {
            cell.isUserInteractionEnabled = true
        } else {
            cell.isUserInteractionEnabled = false
        }

        return cell
    }
}

// MARK: - NetWork

extension MainViewController {
    func getMainInfo() {
        MainAPI.shared.getMainData { [weak self] mainData, statusCode in
            guard let self = self else { return }
            guard let mainData = mainData else { return }
            
            DispatchQueue.main.async {
                guard let data = mainData.data else { return }
                self.mainData = data
                self.dataCount = data.todayWal.count
                
                self.titleView.subTitle = data.subtitle
                
                self.walCollectionView.reloadData()
                self.updateCollectionViewLayout(data.todayWal.count)
                
                var isShownCount: Int = 0
                var canOpenCount: Int = 0
                
                for item in self.mainData.todayWal {
                    if item.isShown {
                        isShownCount += 1
                    }
                    
                    if item.canOpen {
                        canOpenCount += 1
                    }
                }
                
                if canOpenCount == 0 {
                    guard let intDate = Int(self.dateFormatter.string(from: self.date)) else { return }
                    
                    if intDate >= 0 && intDate <= 7 {
                        self.titleView.subTitle = "왈뿡이가 자는 시간이에요. 아침에 만나요!"
                        self.walStatus = .sleeping
                    } else {
                        self.walStatus = .checkedAvailable
                    }
                } else {
                    if isShownCount == canOpenCount {
                        if isShownCount == self.dataCount {
                            self.walStatus = .checkedAll
                        } else {
                            self.walStatus = .checkedAvailable
                        }
                    } else {
                        self.walStatus = .arrived
                    }
                }
            }
        }
    }
    
    private func updateCollectionViewLayout(_ todalWalCount: Int) {
        if todalWalCount == 1 {
            walCollectionView.snp.updateConstraints {
                $0.leading.trailing.equalToSuperview().inset(149)
            }
        } else if todalWalCount == 2 {
            walCollectionView.snp.updateConstraints {
                $0.leading.trailing.equalToSuperview().inset(106)
            }
        } else if todalWalCount == 3 {
            walCollectionView.snp.updateConstraints {
                $0.leading.trailing.equalToSuperview().inset(63)
            }
        } else if todalWalCount == 4 {
            walCollectionView.snp.updateConstraints {
                $0.leading.trailing.equalToSuperview().inset(20)
            }
        }
    }
    
    private func updateMainData(item: Int) {
        MainAPI.shared.updateMainData(item: self.mainData.todayWal[item].id) { [weak self] mainData, error in
            guard let self = self else { return }
            guard let mainData = mainData else { return }
            guard let data = mainData.data else { return }
            
            self.mainData = data
            self.dataCount = data.todayWal.count
            
            DispatchQueue.main.async {
                var isShownCount: Int = 0
                var canOpenCount: Int = 0
                
                for item in self.mainData.todayWal {
                    if item.isShown {
                        isShownCount += 1
                    }
                    
                    if item.canOpen {
                        canOpenCount += 1
                    }
                }
                
                if canOpenCount == 0 {
                    guard let currentTime = Int(self.dateFormatter.string(from: self.date)) else { return }
                    
                    if currentTime >= 0 && currentTime <= 7 {
                        self.titleView.subTitle = "왈뿡이가 자는 시간이에요. 아침에 만나요!"
                        self.walStatus = .sleeping
                    } else {
                        self.walStatus = .checkedAvailable
                    }
                } else {
                    if isShownCount == canOpenCount {
                        if isShownCount == self.dataCount {
                            self.walStatus = .checkedAll
                        } else {
                            self.walStatus = .checkedAvailable
                        }
                    } else {
                        self.walStatus = .arrived
                    }
                }
            }
        }
    }
}
