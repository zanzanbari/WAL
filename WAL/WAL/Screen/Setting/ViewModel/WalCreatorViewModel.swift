//
//  WalCreatorViewModel.swift
//  WAL
//
//  Created by 소연 on 2023/11/04.
//

import Foundation

import RxSwift
import RxCocoa

final class WalCreatorViewModel {
    
    // MARK: - Essential
    
    private(set) var input = Input()
    private(set) var output = Output()
    private(set) var bothways = Bothways()
    private(set) var dependency = Dependency()
    //    private(set) var load: Load // info, load, initialize
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    init() {
        rxBind()
    }
    
    //    init(load: Load) {
    //        self.load = load
    //
    //        rxBind()
    //    }
    
    // MARK: - Helpers
    
    private func rxBind() {
        input.postWal
            .bind(with: self) { owner, args in
                let (type, contents) = args
                owner.postWal(type: type, contents: contents)
            }
            .disposed(by: disposeBag)
    }
    
}

// MARK: - API Request

extension WalCreatorViewModel {
    
    /// 왈소리 크리에이터 만들기
    private func postWal(type: WalCategoryType, contents: String) {
        let param: WalCreatorRequest = .init(categoryType: type.rawValue, contents: contents)
        SettingAPI.shared.postWal(param: param) { [weak self] response, statusCode in
            guard let self else { return }
            guard let statusCode = statusCode else { return }
            
            let networkResult = NetworkResult(rawValue: statusCode) ?? .none
            switch networkResult {
            case .created:
                self.output.wal.accept(.created)
            case .unAuthorized:
                self.requestRefreshToken(requestType: param)
            default:
                self.output.wal.accept(networkResult)
                return
            }
        }
    }
    
    /// 토근 재발급
    private func requestRefreshToken(requestType: WalCreatorRequest) {
        AuthAPI.shared.postReissue { [weak self] response, statusCode in
            guard let _self = self else { return }
            guard let _statusCode = statusCode else { return }
            
            let networkResult = NetworkResult(rawValue: _statusCode) ?? .none
            switch networkResult {
            case .okay:
                print("왈소리 만들기 API 한번 더 연결")
            case .unAuthorized:
                print("로그인 화면으로 이동")
            default:
                break
            }
        }
    }
    
}

// MARK: - ViewModel Structure

extension WalCreatorViewModel {
    
    enum ErrorResult: Error {
        case postWal
    }
    
    struct Input {
        let postWal = PublishRelay<(WalCategoryType, String)>()
    }
    
    struct Output {
        let wal = PublishRelay<NetworkResult>()
    }
    
    /// View <-> ViewModel
    struct Bothways {
        let userInteraction = PublishRelay<Bool>()
        let loading = PublishRelay<Bool>()
    }
    
    /// Service
    struct Dependency {
        
    }
    
    /// Initialze (생성자로 enum 을 필요로 할 경우 해당 enum은 전역으로 선언)
    //    struct Load {
    //
    //    }
    
}
