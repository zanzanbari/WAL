//
//  ObservableType+.swift
//  WAL
//
//  Created by 소연 on 2023/04/28.
//

import RxSwift
import RxCocoa

extension ObservableType {
    
    /// 중복 방지
    func preventDuplication(milliseconds: Int = 500) -> Observable<Element> {
        return asObservable().throttle(.milliseconds(milliseconds),
                                       latest: false,
                                       scheduler: MainScheduler.asyncInstance)
    }
    
}
