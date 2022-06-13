//
//  AlarmCollectionViewCell.swift
//  WAL
//
//  Created by heerucan on 2022/05/02.
//

import UIKit

import Then
import WALKit

//protocol TimeButtonCellSelected: AnyObject {
//    func collectionView(collectionviewcell: TimeButtonCollectionViewCell?, index: Int, didTappedInCollectionViewCell: AlarmCollectionViewCell)
//}

class AlarmCollectionViewCell: BaseCollectionViewCell, ChangeCompleteButtonDelegate {
    
    // MARK: - Properties
    
//    weak var timeButtonSelectedDelegate: TimeButtonCellSelected?
 
    private let timeData = TimeData()
        
    // ✅ 선택된 인덱스를 알기 위한 배열
    var selectedIndex: [Bool] = []
    
    private let titleLabel = UILabel().then {
        $0.font = WALFont.title2.font
        $0.text = "언제 알림이 \n 울리길 원하나요?"
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    private let subtitleLabel = UILabel().then {
        $0.font = WALFont.body7.font
        $0.text = "다중선택 가능해요"
        $0.numberOfLines = 0
    }
    
    public lazy var collectionView = UICollectionView(
        frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
            $0.backgroundColor = .white100
            $0.showsHorizontalScrollIndicator = false
            $0.isScrollEnabled = true
            $0.isUserInteractionEnabled = true
        }
    
    private let collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
    }
    
    public let completeButton = WALPlainButton().then {
        $0.title = "완료"
        $0.isDisabled = true
    }
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        setupLayout()
        setupCollectionView()
        
        // ✅ selectedIndex 배열: 카드 아이템 개수만큼 false로 초기화
        for _ in 0..<timeData.getTimeCount() {
            selectedIndex.append(false)
        }
        
        print("---------selectedIndex: ", selectedIndex)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - InitUI
    
    private func configUI() {
        contentView.backgroundColor = .white100
    }
    
    private func setupLayout() {
        contentView.addSubviews([titleLabel,
                                 subtitleLabel,
                                 collectionView,
                                 completeButton])
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(9)
            make.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(35)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(104)
        }
        
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(50)
        }
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            TimeButtonCollectionViewCell.self,
            forCellWithReuseIdentifier: "TimeButtonCollectionViewCell")
    }
        
    // MARK: - Custom Method

    func touchupCompleteButton(isDisabled: Bool) {
        if selectedIndex == [false, false, false] {
            completeButton.isDisabled = isDisabled
        } else {
            completeButton.isDisabled = !isDisabled
        }
    }
}

extension AlarmCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeButtonCollectionViewCell",
                                                            for: indexPath) as? TimeButtonCollectionViewCell else { return false }
        print("여기야 여기: ", cell.isSelected)
        return true
    }
}

// MARK: - UICollectionViewDataSource

extension AlarmCollectionViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeData.getTimeCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeButtonCollectionViewCell",
            for: indexPath) as? TimeButtonCollectionViewCell
        else { return UICollectionViewCell() }
        cell.setupData(index: indexPath.item)
        cell.completeButtonDelegate = self
        // ✅ 인덱스를 cell의 indexPath로 지정
//        cell.index = indexPath.row
        
        // ✅ 선택된 셀들이 어떤 건지 알기 위함
        /*
         나중에 선택된 셀 유형들 인덱스 번호 가지고 서버 통신 요청할 거 같은데
         4개의 카드중에 2번째, 3번째만 선택되어있다면
         selectedIndex 배열이 [false, true, true, false] 이렇게 있을거잖아?
         true인 값의 인덱스만 사용하면 될 듯!
         */
        selectedIndex[indexPath.row].toggle()
        print("---- 여기는 cell 내 selectedIndex", selectedIndex)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AlarmCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (contentView.frame.width-72)/3, height: 104)
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
