//
//  IndicatorView.swift
//  WAL
//
//  Created by 소연 on 2023/06/10.
//

import UIKit

import WALKit

final class CustomIndicator {
    
    static func showLoading() {
        DispatchQueue.main.async {
            // 최상단 윈도우
            guard let window = UIApplication.shared.windows.last else { return }

            let loadingIndicatorView: UIActivityIndicatorView
            
            // 최상단에 이미 IndicatorView가 있는 경우 그대로 사용
            if let existedView = window.subviews.first(
                where: { $0 is UIActivityIndicatorView } ) as? UIActivityIndicatorView {
                loadingIndicatorView = existedView
            } else { // 없는 경우 새로 생성
                loadingIndicatorView = UIActivityIndicatorView(style: .medium)
                // 로딩이 되는 동안 UI 클릭 방지
                loadingIndicatorView.frame = window.frame
                loadingIndicatorView.color = .gray300

                window.addSubview(loadingIndicatorView)
            }
            loadingIndicatorView.startAnimating()
        }
    }

    static func hideLoading() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.last else { return }
            window.subviews.filter({ $0 is UIActivityIndicatorView })
                .forEach { $0.removeFromSuperview() }
        }
    }
    
}


