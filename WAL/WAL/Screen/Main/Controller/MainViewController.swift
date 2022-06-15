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
    
    fileprivate enum WALStatus {
        case sleeping
        case checkedAll
        case arrived
        
        var subTitle: String {
            switch self {
            case .sleeping:
                return "왈뿡이가 자는 시간이에요. 아침에 만나요!"
            case .checkedAll, .arrived:
                return "다들 밥 잘 먹어! 난 뼈다구가 젤루 좋아"
            }
        }
        
        var content: String {
            switch self {
            case .sleeping:
                return ""
            case .checkedAll:
                return "새로운 왈소리를 기다려보세요"
            case .arrived:
                return "왈소리가 도착했어요\n발바닥을 탭하여 확인해주세요"
            }
        }
        
        var walImage: UIImage {
            switch self {
            case .sleeping:
                return WALIcon.imgWalBBongSleeping.image
            case .checkedAll:
                return WALIcon.imgWalBBongWaiting.image
            case .arrived:
                let walArrivedImageList: [UIImage] = [WALIcon.imgWalBBongArrive1.image,
                                                      WALIcon.imgWalBBongArrive2.image,
                                                      WALIcon.imgWalBBongArrive3.image]
                return walArrivedImageList.randomElement() ?? WALIcon.imgWalBBongArrive1.image
            }
        }
        
    }

    // MARK: - Properties
    
    private lazy var navigationBar = UIView().then {
        $0.backgroundColor = .clear
        $0.addSubviews([addButton, settingButton])
    }
    
    private lazy var addButton = UIButton().then {
        $0.setTitle("", for: .normal)
        $0.backgroundColor = .orange100
        $0.addTarget(self, action: #selector(touchUpAddButton), for: .touchUpInside)
    }
    
    private lazy var settingButton = UIButton().then {
        $0.setTitle("", for: .normal)
        $0.backgroundColor = .mint100
        $0.addTarget(self, action: #selector(touchUpSettingButton), for: .touchUpInside)
    }
    
    private var titleLabel = UILabel().then {
        $0.text = "오늘의 왈소리"
        $0.textColor = .black100
        $0.font = WALFont.title0.font
    }
    
    private var subTitleLabel = UILabel().then {
        $0.text = "다들 밥 잘 먹어! 난 뼈다구가 젤루 좋아"
        $0.textColor = .black100
        $0.font = WALFont.body3.font
    }
    
    private var walImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    private var walLottieView: AnimationView = .init(name: "paw").then {
        $0.isHidden = true
    }
    
    private var contentLabel = UILabel().then {
        $0.font = WALFont.body3.font
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

    private var dataCount: Int = 0
    
    private let date = Date()
    private let dateFormatter = DateFormatter().then {
        $0.locale = Locale(identifier: "ko_kr")
        $0.timeZone = TimeZone(abbreviation: "ko_kr")
        $0.dateFormat = "HH:mm"
    }
    
    private var walArrivedImageList: [UIImage] = [WALIcon.imgWalBBongArrive1.image,
                                                  WALIcon.imgWalBBongArrive2.image,
                                                  WALIcon.imgWalBBongArrive3.image]
    
    private var walStatus: WALStatus = .arrived {
        didSet {
            walImageView.image = walStatus.walImage
            
            subTitleLabel.text = walStatus.subTitle
            subTitleLabel.addLetterSpacing()
            
            contentLabel.text = walStatus.content
            contentLabel.addLetterSpacing()
            
            switch walStatus {
            case .sleeping:
                walCollectionView.isHidden = true
            case .checkedAll, .arrived:
                walCollectionView.isHidden = false
            }
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configNavigationUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupLayout()
        setupCollectionView()
        checkTime()
        DispatchQueue.main.async {
            self.dataCount = MainDataModel.mainData.count
            self.walCollectionView.reloadData()
            
            if self.dataCount == 1 {
                self.walCollectionView.snp.updateConstraints {
                    $0.leading.trailing.equalToSuperview().inset(149)
                }
            } else if self.dataCount == 2 {
                self.walCollectionView.snp.updateConstraints {
                    $0.leading.trailing.equalToSuperview().inset(106)
                }
            } else if self.dataCount == 3 {
                self.walCollectionView.snp.updateConstraints {
                    $0.leading.trailing.equalToSuperview().inset(63)
                }
            } else if self.dataCount == 4 {
                self.walCollectionView.snp.updateConstraints {
                    $0.leading.trailing.equalToSuperview().inset(20)
                }
            }
        }
    }
    
    // MARK: - Init UI
    
    private func configNavigationUI() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func configUI() {
        view.backgroundColor = .white100
    }
    
    private func setupLayout() {
        view.addSubviews([navigationBar,
                          titleLabel,
                          subTitleLabel,
                          walLottieView,
                          walImageView,
                          contentLabel,
                          walCollectionView,
                          walContentView])
        
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
            $0.top.equalTo(navigationBar.snp.bottom).offset(10)
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
            $0.top.equalTo(navigationBar.snp.bottom).offset(124)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(300)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(walImageView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(313)
        }
        
        walCollectionView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(73)
        }
        
        walContentView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(93)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(313)
            $0.height.equalTo(383)
        }
    }
    
    // MARK: - Custom Method
    
    private func setupCollectionView() {
        walCollectionView.delegate = self
        walCollectionView.dataSource = self
        
        walCollectionView.register(MainItemCell.self, forCellWithReuseIdentifier: MainItemCell.cellIdentifier)
    }
    
    private func checkTime() {
        if dateFormatter.string(from: date) == "00:00" {
            walStatus = .sleeping
        } else {
            walStatus = .arrived
        }
    }
    
    // MARK: - @objc
    
    @objc func touchUpAddButton() {
        
    }
    
    @objc func touchUpSettingButton() {
        let vc = SettingViewController()
        navigationController?.pushViewController(vc, animated: true)
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
        guard let cell = collectionView.cellForItem(at: indexPath) as? MainItemCell else {
            return true
        }
        
        if cell.isSelected {
            titleLabel.isHidden = false
            subTitleLabel.isHidden = false
            
            walContentView.isHidden = true
            
            collectionView.deselectItem(at: indexPath, animated: false)
            
            return false
        } else {
            titleLabel.isHidden = true
            subTitleLabel.isHidden = true
            
            walContentView.isHidden = false
            walContentView.content = MainDataModel.mainData[indexPath.item].content
            
            let walType = MainDataModel.mainData[indexPath.item].walType
            if walType == 0 {
                walContentView.walContentType = .fun
            } else if walType == 1 {
                walContentView.walContentType = .angry
            } else if walType == 2 {
                walContentView.walContentType = .love
            } else if walType == 3 {
                walContentView.walContentType = .cheer
            } else {
                walContentView.walContentType = .angry
            }
            
            return true
        }
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainItemCell.cellIdentifier, for: indexPath) as? MainItemCell else { return UICollectionViewCell() }
        cell.setupData(MainDataModel.mainData[indexPath.item])
        
        if MainDataModel.mainData[indexPath.item].canOpen {
            cell.isUserInteractionEnabled = true
        } else {
            cell.isUserInteractionEnabled = false
        }

        return cell
    }
}
