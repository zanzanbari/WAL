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
    private let timeFormatter = DateFormatter().then {
        $0.locale = Locale(identifier: "ko_kr")
        $0.timeZone = TimeZone(abbreviation: "ko_kr")
        $0.dateFormat = "HH"
    }
    
    private let dateFormatter = DateFormatter().then {
        $0.locale = Locale(identifier: "ko_kr")
        $0.timeZone = TimeZone(abbreviation: "ko_kr")
        $0.dateFormat = "yyyy-MM-dd"
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
                owner.requestTodayWal()
            }
            .disposed(by: disposeBag)
        
        input.reqImageUrl
            .bind(with: self) { owner, res in
                let (image, imageName) = res
                owner.converImageToUrl(image: image, imageName: imageName)
            }
            .disposed(by: disposeBag)
        
        input.reqOpenWal
            .bind(with: self) { owner, res in
                owner.requestOpenWal(id: res)
            }
            .disposed(by: disposeBag)
        
        input.reqSubtitle
            .bind(with: self) { owner, _ in
                // UserDefaults에서 저장된 정보를 갖고 올 때
                guard let _subtitleStatus = owner.getSubtitleFromUserDefaults() else {
                    // 최초 유저라면 저장된 정보가 없기 때문에 API 요청 
                    owner.requestSubtitle()
                    return
                }
                
                // 메인에 진입했을 때 왈소리를 조회한 날짜와 이전에 조회한(UserDefaults에 저장) 날짜를 비교해서
                if owner.dateFormatter.string(from: _subtitleStatus.date) == owner.dateFormatter.string(from: Date()) {
                    // 같은 날이라면 이전에 저장된 subtitle을 보여주고
                    owner.output.subTitle.accept(_subtitleStatus.subtitle)
                } else {
                    // 다른 날이라면 매일 갱신되어야 하므로 새로 API 요청
                    owner.requestSubtitle()
                }
            }
            .disposed(by: disposeBag)
    }
    
    func handleWalState(todayWalList: [TodayWal]?) {
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
        
        switch canOpenCount {
        case 0:
            guard let intDate = Int(timeFormatter.string(from: date)) else { return }
            
//            if intDate >= 0 && intDate <= 7 {
//                output.subTitle.accept("왈뿡이가 자는 시간이에요. 아침에 만나요!")
//                output.walStatus.accept(.sleeping)
//            } else {
//                output.walStatus.accept(.checkedAvailable)
//            }
            
            // TODO: - Remove
            output.walStatus.accept(.checkedAvailable)
        default:
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
    
    private func setSubtitleToUserDefaults(date: Date, subtitle: String) {
        let subtitle = MainSubtitleStatus(date: date, subtitle: subtitle)

        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(subtitle)
            UserDefaults.standard.set(data, forKey: "mainSubtitle")
        } catch {
            print(error)
        }
    }
    
    private func getSubtitleFromUserDefaults() -> MainSubtitleStatus? {
        let decoder = JSONDecoder()
        
        if let data = UserDefaults.standard.data(forKey: "mainSubtitle") {
            do {
                let subtitle = try decoder.decode(MainSubtitleStatus.self, from: data)
                return subtitle
            } catch {
                print(error)
            }
        }
        
        return nil
    }
    
}

// MARK: - API Request

extension MainViewModel {
    
    private func requestTodayWal() {
        MainAPI.shared.getMainData { [weak self] mainData, statusCode in
            guard let self = self else { return }
            guard let _todayWalInfo = mainData?.todayWalInfo else { return }
            
            self.output.todayWal.accept(_todayWalInfo)
            self.output.todayWalCount.accept(_todayWalInfo.count)
            self.handleWalState(todayWalList: _todayWalInfo)
        }
    }
    
    private func requestOpenWal(id: Int) {
        MainAPI.shared.updateMainData(id: id) { [weak self] _, statusCode in
            guard let self = self else { return }
            self.output.openWal.accept(statusCode)
        }
    }
    
    private func requestSubtitle() {
        MainAPI.shared.getMainSubtitle { [weak self] subtitle, statusCase in
            guard let self = self else { return }
            guard let _subtitle = subtitle?.todaySubtitle else { return }
            
            guard let _statusCase = statusCase else {
                self.setSubtitleToUserDefaults(date: Date(), subtitle: _subtitle)
                self.output.subTitle.accept(_subtitle)
                return
            }
            
            
        }
    }
    
}

// MARK: - ViewModel Structure

extension MainViewModel {
    
    enum Error {
        case reqSubtitle
    }
    
    struct Input {
        let reqTodayWal = PublishRelay<Void>()
        let reqImageUrl = PublishRelay<(UIImage, String)>()
        let reqOpenWal = PublishRelay<Int>()
        let checkTime = PublishRelay<Int>()
        let reqSubtitle = PublishRelay<Void>()
    }
    
    struct Output {
        let todayWal = PublishRelay<[TodayWal]>()
        let todayWalCount = BehaviorRelay<Int>(value: 0)
        let subTitle = BehaviorRelay<String>(value: "")
        let walStatus = PublishRelay<WalStatus>()
        let imageUrl = PublishRelay<URL?>()
        let openWal = PublishRelay<Int?>()
    }
    
}
