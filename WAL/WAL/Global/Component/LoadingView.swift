//
//  LoadingView.swift
//  WAL
//
//  Created by heerucan on 2022/09/25.
//

import UIKit

import Lottie
import SnapKit

final class LoadingView: UIView {
    
    // MARK: - Property
    
    private var loadingAnimationView = LottieAnimationView(name: Constant.Lottie.loading)
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
        setupLayout()
        play()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI & Layout
    
    private func configureUI() {
        self.backgroundColor = .black100.withAlphaComponent(0)
    }
    
    private func setupLayout() {
        self.addSubview(loadingAnimationView)
        
        loadingAnimationView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
    }
    
    // MARK: - Custom Method
    
    func play() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.backgroundColor = .black100.withAlphaComponent(0.5)
            self.loadingAnimationView.play()
            self.loadingAnimationView.loopMode = .loop
        })
    }
    
    func hide() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve, animations: {
            self.loadingAnimationView.stop()
            self.loadingAnimationView.removeFromSuperview()
        })
    }
}
