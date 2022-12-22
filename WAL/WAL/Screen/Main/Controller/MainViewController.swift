//
//  MainViewController.swift
//  WAL
//
//  Created by Thisisme Hi on 2022/04/01.
//

import UIKit

import Then
import WALKit
import Lottie

final class MainViewController: UIViewController {

    // MARK: - UI Property
    
    private lazy var navigationBar = UIView().then {
        $0.backgroundColor = .clear
        $0.addSubviews([addButton, settingButton])
    }
    
    private lazy var addButton = UIButton().then {
        $0.setImage(WALIcon.btnPlus.image, for: .normal)
        $0.addTarget(self, action: #selector(touchupAddButton), for: .touchUpInside)
    }
    
    private lazy var settingButton = UIButton().then {
        $0.setImage(WALIcon.btnSetting.image, for: .normal)
        $0.addTarget(self, action: #selector(touchupSettingButton), for: .touchUpInside)
    }
    
    private var titleLabel = UILabel().then {
        $0.text = "오늘의 왈소리"
        $0.textColor = .black100
        $0.font = WALFont.title0.font
    }
    
    private var subTitleLabel = UILabel().then {
        $0.textColor = .black100
        $0.font = WALFont.body3.font
    }
    
    private var walImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    private var walLottieView: LottieAnimationView = .init(name: "paw").then {
        $0.isHidden = true
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
        $0.addTarget(self, action: #selector(touchupShareButton), for: .touchUpInside)
        $0.isHidden = true
    }
    
    // MARK: - Property

    private var dataCount: Int = 0
    
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
                [titleLabel, subTitleLabel, walImageView, contentLabel].forEach {
                    $0.isHidden = true
                }
                
                [walContentView, shareButton].forEach {
                    $0.isHidden = false
                }
                
            } else {
                [titleLabel, subTitleLabel, walImageView, contentLabel].forEach {
                    $0.isHidden = false
                }
                
                [walContentView, shareButton].forEach {
                    $0.isHidden = true
                }
            }
        }
    }
    
    private var mainData = MainResponse(subtitle: "", todayWal: [])
    
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
        view.addSubviews([navigationBar,
                          titleLabel,
                          subTitleLabel,
                          walLottieView,
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
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(20)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(20)
        }
        
        walLottieView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(139)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(88)
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
    
    // MARK: - Custom Method
    
    private func setupCollectionView() {
        walCollectionView.delegate = self
        walCollectionView.dataSource = self
        
        walCollectionView.register(MainItemCell.self, forCellWithReuseIdentifier: MainItemCell.cellIdentifier)
    }
    
    private func saveImageOnPhone(image: UIImage, image_name: String) -> URL? {
        let imagePath: String = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(image_name).png"
        let imageUrl: URL = URL(fileURLWithPath: imagePath)
        
        do {
            try image.pngData()?.write(to: imageUrl)
            return imageUrl
        } catch {
            return nil
        }
    }
    
    private func setMainStatus() {
        if titleLabel.isHidden == true {
            [titleLabel, subTitleLabel, walImageView, contentLabel].forEach {
                $0.isHidden = false
            }
            
            [walContentView, shareButton].forEach {
                $0.isHidden = true
            }
        }
    }
    
    // MARK: - @objc
    
    @objc func touchupAddButton() {
        let viewController = CreateViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func touchupSettingButton() {
        let viewController = SettingViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func touchupShareButton() {
        let imageToShare = walContentView.toImage()

        let activityItems : NSMutableArray = []
        activityItems.add(imageToShare)

        guard let url = saveImageOnPhone(image: imageToShare, image_name: "WAL") else {
            return
        }
        
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.addToReadingList]
        
        self.present(activityVC, animated: true, completion: nil)
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
                
                self.subTitleLabel.text = data.subtitle
                self.subTitleLabel.addLetterSpacing()
                
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
                        self.subTitleLabel.text = "왈뿡이가 자는 시간이에요. 아침에 만나요!"
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
                        self.subTitleLabel.text = "왈뿡이가 자는 시간이에요. 아침에 만나요!"
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
