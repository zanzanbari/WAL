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
    private(set) var errorResult = ErrorResult()
    
    // MARK: - Properties
    
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
        
        input.reqTodayWalOpen
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
                
                let dateFormatter = DateFormatter().then {
                    $0.locale = Locale(identifier: "ko_kr")
                    $0.timeZone = TimeZone(abbreviation: "ko_kr")
                    $0.dateFormat = "yyyy-MM-dd"
                }
                
                // 메인에 진입했을 때 왈소리를 조회한 날짜와 이전에 조회한(UserDefaults에 저장) 날짜를 비교해서
                if dateFormatter.string(from: _subtitleStatus.date) == dateFormatter.string(from: Date()) {
                    
                    if _subtitleStatus.subtitle == "" {
                        owner.requestSubtitle()
                        return
                    } else {
                        // 같은 날이라면 이전에 저장된 subtitle을 보여주고
                        owner.output.subTitle.accept(_subtitleStatus.subtitle)
                    }
                    
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
            
            let timeFormatter = DateFormatter().then {
                $0.locale = Locale(identifier: "ko_kr")
                $0.timeZone = TimeZone(abbreviation: "ko_kr")
                $0.dateFormat = "HH"
            }
            
            guard let intDate = Int(timeFormatter.string(from: Date())) else { return }
            
            if intDate >= 0 && intDate <= 7 {
                output.subTitle.accept("왈뿡이가 자는 시간이에요. 아침에 만나요!")
                output.walStatus.accept(.sleeping)
            } else {
                output.walStatus.accept(.checkedAvailable)
            }
            
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
            UserDefaults.standard.set("", forKey: "mainSubtitle")
            print("[MAIN] DEBUG: - UserDefaults SET \(error)")
        }
    }
    
    private func getSubtitleFromUserDefaults() -> MainSubtitleStatus? {
        let decoder = JSONDecoder()
        
        if let data = UserDefaults.standard.data(forKey: "mainSubtitle") {
            do {
                let subtitle = try decoder.decode(MainSubtitleStatus.self, from: data)
                return subtitle
            } catch {
                print("[MAIN] DEBUG: - UserDefaults GET \(error)")
                return nil
            }
        }
        
        return nil
    }
    
}

// MARK: - Enums

extension MainViewModel {
    
    enum MainRequestType {
        case todayWal
        case todayWalOpen
        case subtitle
    }
    
}

// MARK: - API Request

extension MainViewModel {
    /// 오늘의 왈소리 GET
    private func requestTodayWal() {
        MainAPI.shared.getMainData { [weak self] mainData, statusCode in
            guard let _self = self else { return }
            guard let _statusCode = statusCode else { return }
            
            let networkResult = NetworkResult(rawValue: _statusCode) ?? .none
            switch networkResult {
            case .okay:
                guard let _todayWalInfo = mainData?.todayWalInfo else { return }
                _self.output.todayWal.accept(_todayWalInfo)
                _self.output.todayWalCount.accept(_todayWalInfo.count)
                _self.handleWalState(todayWalList: _todayWalInfo)
            case .unAuthorized:
                _self.requestRefreshToken(requestType: .todayWal, id: nil)
            default:
                print("[MAIN] DEBUG: - \(_statusCode)")
            }
            _self.errorResult.reqTodayWal.accept(networkResult)
        }
    }
    
    /// 왈소리 확인 PATCH
    private func requestOpenWal(id: Int) {
        MainAPI.shared.updateMainData(id: id) { [weak self] _, statusCode in
            guard let _self = self else { return }
            guard let _statusCode = statusCode else { return }
            
            let networkResult = NetworkResult(rawValue: _statusCode) ?? .none
            switch networkResult {
            case .okay:
                _self.output.openWal.accept(_statusCode)
            case .unAuthorized:
                _self.requestRefreshToken(requestType: .todayWalOpen, id: nil)
            default:
                print("[MAIN] DEBUG: - \(_statusCode)")
            }
        }
    }
    
    /// 오늘의 서브타이틀 GET
    private func requestSubtitle() {
        MainAPI.shared.getMainSubtitle { [weak self] subtitle, statusCode in
            guard let _self = self else { return }
            guard let _subtitle = subtitle?.todaySubtitle else { return }
            guard let _statusCode = statusCode else { return }
            
            let networkResult = NetworkResult(rawValue: _statusCode) ?? .none
            switch networkResult {
            case .okay:
                _self.setSubtitleToUserDefaults(date: Date(), subtitle: _subtitle)
                _self.output.subTitle.accept(_subtitle)
            case .unAuthorized:
                _self.requestRefreshToken(requestType: .subtitle, id: nil)
            default:
                print("[MAIN] DEBUG: - \(_statusCode)")
            }
        }
    }
    
    /// 토큰만료 시 재발급
    private func requestRefreshToken(requestType: MainRequestType, id: Int?) {
        AuthAPI.shared.postReissue { [weak self] response, statusCode in
            guard let _self = self else { return }
            guard let _statusCode = statusCode else { return }
            
            let networkResult = NetworkResult(rawValue: _statusCode) ?? .none
            switch networkResult {
            case .okay:
                // 재발급 성공 시 다시 함수 호출
                _self.requestAPI(requestType: requestType, id: id)
            case .unAuthorized:
                // 소셜 토큰 만료 시 로그인 화면으로 이동
                _self.output.socialTokenExpired.accept(true)
            default:
                break
            }
        }
    }
    
    private func requestAPI(requestType: MainRequestType, id: Int?) {
        switch requestType {
        case .todayWal:
            requestTodayWal()
        case .todayWalOpen:
            guard let _id = id else { return }
            requestOpenWal(id: _id)
        case .subtitle:
            requestSubtitle()
        }
    }
    
}

// MARK: - ViewModel Structure

extension MainViewModel {
    
    struct ErrorResult {
        let reqTodayWal = PublishRelay<NetworkResult>()
        let reqTodayWalOpen = PublishRelay<NetworkResult>()
        let reqSubtitle = PublishRelay<NetworkResult>()
    }
    
    struct Input {
        let reqTodayWal = PublishRelay<Void>()
        let reqTodayWalOpen = PublishRelay<Int>()
        let reqSubtitle = PublishRelay<Void>()
        let reqImageUrl = PublishRelay<(UIImage, String)>()
        let checkTime = PublishRelay<Int>()
    }
    
    struct Output {
        let todayWal = PublishRelay<[TodayWal]>()
        let todayWalCount = BehaviorRelay<Int>(value: 0)
        let subTitle = PublishRelay<String>()
        let walStatus = PublishRelay<WalStatus>()
        let openWal = PublishRelay<Int>()
        let imageUrl = PublishRelay<URL?>()
        
        /// 소셜 토큰 만료 시
        let socialTokenExpired = PublishRelay<Bool>()
    }
    
}
