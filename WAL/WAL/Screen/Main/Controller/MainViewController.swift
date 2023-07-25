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
    
    private lazy var titleView = MainTitleView()
    
    private lazy var walImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    private lazy var contentLabel = UILabel().then {
        $0.font = WALFont.body7.font
        $0.textColor = .gray100
        $0.numberOfLines = 0
        $0.isHidden = false
        $0.textAlignment = .center
    }
    
    private lazy var walCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 9
        layout.sectionInset = .zero
        
        return UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            $0.isScrollEnabled = false
            $0.delegate = self
            MainItemCell.register($0)
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
    
    private var isSelected: Bool = false {
        didSet {
            updateSelectedUI(isSelected)
        }
    }
    
    private var todayWalList: [TodayWal] = []
    private var selectedItemIndex: Int = 0
    
    private let viewModel: MainViewModel
    private let disposeBag = DisposeBag()
    
    typealias ErrorInfo<T> = (error: Error, type: T?)
    
    // MARK: - Initializer
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configNavigationUI()
        setMainStatus()
        NotificationCenter.default.addObserver(self, selector: #selector(getNotification), name: NSNotification.Name.enterMain, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupLayout()
        rxBindOutput()
        rxBindView()
        rxBindInput()
//        rxBindOutputError()
    }
    
    // MARK: - Init UI
    
    private func configNavigationUI() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func configUI() {
        view.backgroundColor = .white100
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
    
    private func rxBindOutput() {
        
        viewModel.output.todayWalCount
            .bind(with: self) { owner, res in
                owner.updateCollectionViewLayout(res)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.todayWal
            .do(onNext: { [weak self] res in
                self?.todayWalList = res
            })
            .bind(to: walCollectionView.rx.items(cellIdentifier: MainItemCell.cellIdentifier, cellType: MainItemCell.self)) {  index, data, cell in
                cell.setupData(data)
                cell.isUserInteractionEnabled = data.getOpenStatus()
            }
            .disposed(by: disposeBag)
        
        
        viewModel.output.subTitle
            .bind(with: self) { owner, res in
                owner.titleView.subTitle = res
            }
            .disposed(by: disposeBag)
        
        viewModel.output.walStatus
            .bind(with: self) { owner, res in
                owner.walImageView.image = res.walImage

                owner.contentLabel.text = res.content
                owner.contentLabel.addLetterSpacing()
                
                owner.walCollectionView.isHidden = res == .sleeping ? true : false
            }
            .disposed(by: disposeBag)
        
        viewModel.output.imageUrl
            .bind(with: self) { owner, res in
                guard let _url = res else { return }
                let activityViewController = UIActivityViewController(activityItems: [_url], applicationActivities: nil)
                activityViewController.excludedActivityTypes = [UIActivity.ActivityType.addToReadingList]
                owner.present(activityViewController, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.openWal
            .compactMap { NetworkResult(rawValue: $0) ?? NetworkResult.none }
            .bind(with: self) { owner, networkResult in
                
                switch networkResult {
                case .okay:
                    owner.todayWalList[owner.selectedItemIndex].showStatus = "OPEN"
                    owner.viewModel.handleWalState(todayWalList: owner.todayWalList)
                default:
                    owner.showToast(message: "Error : \(networkResult)")
                }
                
            }
            .disposed(by: disposeBag)
        
        viewModel.output.socialTokenExpired
            .bind(with: self) { owner, expired in
                switch expired {
                case true:
                    // 소셜토큰이 만료 > 로그인 화면으로 이동 (재로그인)
                    owner.pushToLoginView()
                case false:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func rxBindView() {
        shareButton
            .rx
            .tap
            .preventDuplication()
            .bind(with: self, onNext: { owner, _ in
                owner.viewModel.input.reqImageUrl.accept((owner.walContentView.toImage(), "왈"))
            })
            .disposed(by: disposeBag)
        
        addButton
            .rx
            .tap
            .preventDuplication()
            .bind(with: self, onNext: { owner, _ in
                owner.navigationController?.pushViewController(CreateViewController(), animated: true)
            })
            .disposed(by: disposeBag)
        
        settingButton
            .rx
            .tap
            .preventDuplication()
            .bind(with: self, onNext: { owner, _ in
                self.navigationController?.pushViewController(SettingViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func rxBindInput() {
        viewModel.input.reqTodayWal.accept(())
        viewModel.input.reqSubtitle.accept(())
    }
    
    private func rxBindOutputError() {
        viewModel.errorResult.reqTodayWal
            .do(onNext: { networkResult in
                CustomIndicator.showLoading()
            })
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, networkResult in
                
                switch networkResult {
                case .okay:
                    CustomIndicator.hideLoading()
                default:
                    break
                }
                
                owner.showToast(message: "\(networkResult) error")
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Custom Method
    
    private func setMainStatus() {
        if titleView.isHidden {
            [titleView, walImageView, contentLabel].forEach {
                $0.isHidden = false
            }
            
            [walContentView, shareButton].forEach {
                $0.isHidden = true
            }
        }
    }
    
    private func updateCollectionViewLayout(_ todalWalCount: Int) {
        var horizontalInset: CGFloat = 0.0
        switch todalWalCount {
        case 1:
            horizontalInset = 149
        case 2:
            horizontalInset = 106
        case 3:
            horizontalInset = 63
        case 4:
            horizontalInset = 20
        default:
            return
        }
        
        walCollectionView.snp.updateConstraints {
            $0.leading.trailing.equalToSuperview().inset(horizontalInset)
        }
    }
    
    private func updateSelectedUI(_ isSelected: Bool) {
        if isSelected {
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
    
    // MARK: - @objc
    
    @objc func getNotification() {
        setMainStatus()
        viewModel.input.reqTodayWal.accept(())
        viewModel.input.reqSubtitle.accept(())
    }
}

// MARK: - UICollectionView Protocol

extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = CGFloat(77)
        let cellHeight = collectionView.frame.height
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MainItemCell else { return true }
        let todayWal = todayWalList[indexPath.item]
        
        // 왈소리를 보고 있는 상태라면
        if cell.isSelected {
            // cell selected 상태를 false로 바꿔서 왈뿡이가 보이는(메인) 화면으로 전환
            isSelected = false
            collectionView.deselectItem(at: indexPath, animated: false)
            return false
        } else {
            // 왈뿡이를 보고 있는 상태라면 cell selected 상태를 true로 바꿔서 왈소리를 볼 수 있는 화면으로 전환
            isSelected = true
            
            // 왈소리가 있다면 표기, 없다면 "-" 표기
            if let _message = todayWal.message {
                walContentView.content = _message
            } else {
                walContentView.content = "-"
            }
            
            // 왈소리의 유형에 따른 왈뿡이 UI 변화
            walContentView.walCategoryType = todayWal.getCategoryType()
            return true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let showStatus = todayWalList[indexPath.item].getShowStatus()
        
        // 사용자가 열어보지 않은 왈소리에 대해서만 API 호출
        if !showStatus {
            guard let _todayWalId = todayWalList[indexPath.item].todayWalId else { return }
            selectedItemIndex = indexPath.item
            viewModel.input.reqTodayWalOpen.accept(_todayWalId)
        }
        
    }
    
}
