//
//  CategoryCollectionViewCell.swift
//  WAL
//
//  Created by heerucan on 2022/05/02.
//

import UIKit

import Then
import WALKit

class CategoryCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Properties
    
    private let cardData = CardData()
    
    private let cellWidth: CGFloat = 253
    private let cellHeight: CGFloat = 322
    private let cellSpacing: CGFloat = 18
    
    private var barWidth: CGFloat = 0
    
    // ✅ 선택된 인덱스를 알기 위한 배열
    var selectedIndex: [Bool] = []
    
    private let titleLabel = UILabel().then {
        $0.font = WALFont.title2.font
        $0.text = "태끼방구님이 받고싶은 \n 왈소리 유형은?"
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    private let subtitleLabel = UILabel().then {
        $0.font = WALFont.body7.font
        $0.text = "다중선택 가능해요"
        $0.numberOfLines = 0
    }
        
    private lazy var collectionView = UICollectionView(
        frame: .zero, collectionViewLayout: makeLayout()).then {
            $0.backgroundColor = .white100
            $0.showsHorizontalScrollIndicator = false
            $0.isScrollEnabled = false
            $0.isPagingEnabled = false
            $0.isUserInteractionEnabled = true
        }
    
    private lazy var slideBackView = UIView().then {
        $0.backgroundColor = .gray500
        $0.makeRound(radius: 1)
        $0.addSubview(slideBar)
    }
    
    private let slideBar = UIView().then {
        $0.backgroundColor = .orange100
        $0.makeRound(radius: 1)
    }
    
    public let nextButton = WALPlainButton().then {
        $0.title = "다음"
        $0.isDisabled = false
    }
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        setupLayout()
        setupCollectionView()
        
        // ✅ selectedIndex 배열: 카드 아이템 개수만큼 false로 초기화
        for _ in 0..<cardData.getCardCount() {
            selectedIndex.append(false)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - InitUI
    
    private func configUI() {
        contentView.backgroundColor = .white100
        barWidth = (contentView.frame.width-61*2)/4
    }
    
    private func setupLayout() {
        contentView.addSubviews([titleLabel,
                                 subtitleLabel,
                                 collectionView,
                                 slideBackView,
                                 nextButton])
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(9)
            make.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(50)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(322)
        }
        
        slideBackView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(61)
            make.height.equalTo(2)
        }
        
        slideBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalTo(barWidth)
            make.height.equalTo(2)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(50)
        }
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            CardCollectionViewCell.self,
            forCellWithReuseIdentifier: "CardCollectionViewCell")
    }
}

// MARK: - UICollectionViewDataSource

extension CategoryCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardData.getCardCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell",
            for: indexPath) as? CardCollectionViewCell
        else { return UICollectionViewCell() }
        cell.setupData(index: indexPath.item)
        
        // ✅ 인덱스를 cell의 indexPath로 지정
        cell.index = indexPath.row
        
        // ✅ 선택된 셀들이 어떤 건지 알기 위함
        /*
         나중에 선택된 셀 유형들 인덱스 번호 가지고 서버 통신 요청할 거 같은데
         4개의 카드중에 2번째, 3번째만 선택되어있다면
         selectedIndex 배열이 [false, true, true, false] 이렇게 있을거잖아?
         true인 값의 인덱스만 사용하면 될 듯!
         */
        selectedIndex[indexPath.row].toggle()
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CategoryCollectionViewCell: UICollectionViewDelegateFlowLayout { }

// MARK: - UICollectionViewCompositionalLayout

extension CategoryCollectionViewCell {
    private func makeLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout(section: createCellSection())
        let config = UICollectionViewCompositionalLayoutConfiguration()
        layout.configuration = config
        
        return layout
    }
    
    private func createCellSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: 9, bottom: 0, trailing: 9)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(cellWidth+cellSpacing),
            heightDimension: .absolute(cellHeight))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.visibleItemsInvalidationHandler = ({ (visibleItems, point, env) in
            // 기기에 따라 point.x 값을 대응해준 식
            let pointX = (self.contentView.frame.width - self.slideBackView.frame.width) / 2 - 9
            // 항상 처음 초기값이 0이 되게 해주기 위해서 point.x + pointX
            let value = CGFloat(point.x + pointX)
            // 현재 카드 cell가 몇 번째 index인지 알기 위해서 값을 구해줬다
            let cellIndex = round(value/(self.cellWidth + self.cellSpacing))
            // slideBar의 Leading 값 : (초기값 - 간격*셀현재인덱스)/4
            let slideBarLeading = (value - self.cellSpacing * cellIndex) / 4
            print("----- value: ", value)
            print("----- cell indexPath: ", round(value/(self.cellWidth + self.cellSpacing)))
            print("----- slideBarLeading: ", (value - self.cellSpacing * cellIndex)/4)
            if value >= 0 {
                self.slideBar.snp.updateConstraints { make in
                    make.leading.equalToSuperview().inset(slideBarLeading)
                }
            }
        })
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: 0, bottom: 0, trailing: 0)
        return section
    }
}
