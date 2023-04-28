//
//  MainViewModel.swift
//  WAL
//
//  Created by 소연 on 2023/01/25.
//

import Foundation

import RxCocoa
import RxSwift

final class MainViewModel {
    
    // MARK: - Essential
    
    private(set) var input = Input()
    private(set) var output = Output()
    
    // MARK: - Properties
    
    private let date = Date()
    private let dateFormatter = DateFormatter().then {
        $0.locale = Locale(identifier: "ko_kr")
        $0.timeZone = TimeZone(abbreviation: "ko_kr")
        $0.dateFormat = "HH"
    }
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    init() {
        rxBind()
    }
    
    // MARK: - Helpers
    
    private func rxBind() {
        input.reqTodayWal
            .bind(with: self) { owner, _ in
                owner.requestMainInfo()
            }
            .disposed(by: disposeBag)
        
        input.reqImageUrl
            .bind(with: self) { owner, res in
                let (image, imageName) = res
                owner.converImageToUrl(image: image, imageName: imageName)
            }
            .disposed(by: disposeBag)
    }
    
    private func handleWalState(todayWalList: [TodayWal]?) {
        guard let _todayWalList = todayWalList else { return }
        
        var isShownCount: Int = 0
        var canOpenCount: Int = 0
        
        for item in _todayWalList {
            if item.getShowStatus() {
                isShownCount += 1
            }
            
            if item.getOpenStatus() {
                canOpenCount += 1
            }
        }
        
        if canOpenCount == 0 {
            guard let intDate = Int(dateFormatter.string(from: date)) else { return }
            
            output.walStatus.accept(.checkedAvailable)
            if intDate >= 0 && intDate <= 7 {
                output.subTitle.accept("왈뿡이가 자는 시간이에요. 아침에 만나요!")
                output.walStatus.accept(.sleeping)
            } else {
                output.walStatus.accept(.checkedAvailable)
            }
        } else {
            if isShownCount == canOpenCount {
                output.walStatus.accept(isShownCount == output.todayWalCount.value ? .checkedAll : .checkedAvailable)
            } else {
                output.walStatus.accept(.arrived)
            }
        }
        
    }
    
    private func converImageToUrl(image: UIImage, imageName: String) {
        let imagePath: String = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(imageName).png"
        let imageUrl: URL = URL(fileURLWithPath: imagePath)
        
        do {
            try image.pngData()?.write(to: imageUrl)
            output.imageUrl.accept(imageUrl)
        } catch {
            output.imageUrl.accept(nil)
        }
    }
    
}

// MARK: - API Request

extension MainViewModel {
    private func requestMainInfo() {
        
        MainAPI.shared.getMainData { [weak self] mainData, statusCode in
            guard let self = self else { return }
//            guard let data = mainData else { return }
            
            let todayWalInfo = [TodayWal(todayWalId: 1, timeType: "NIGHT", categoryType: "COMEDY", message: "더미데이터입니다더미데이터입니다", showStatus: "CLOSED", openStatus: "ABLE"),
                                TodayWal(todayWalId: 1, timeType: "NIGHT", categoryType: "COMEDY", message: "더미데이터입니다더미데이터입니다", showStatus: "CLOSED", openStatus: "ABLE"),
                                TodayWal(todayWalId: 1, timeType: "NIGHT", categoryType: "COMEDY", message: "더미데이터입니다더미데이터입니다", showStatus: "CLOSED", openStatus: "ABLE")]
            
            self.output.todayWal.accept(todayWalInfo)
            self.output.todayWalCount.accept(todayWalInfo.count)
            self.handleWalState(todayWalList: todayWalInfo)
        }
    }
    
}

// MARK: - ViewModel Structure

extension MainViewModel {
    
    struct Input {
        let reqTodayWal = PublishRelay<Void>()
        let reqImageUrl = PublishRelay<(UIImage, String)>()
    }
    
    struct Output {
        let todayWal = PublishRelay<[TodayWal]>()
        let todayWalCount = BehaviorRelay<Int>(value: 0)
        let subTitle = BehaviorRelay<String>(value: "")
        let walStatus = PublishRelay<WALStatus>()
        let imageUrl = PublishRelay<URL?>()
    }
    
}
