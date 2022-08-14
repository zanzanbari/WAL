//
//  Protocol.swift
//  WAL
//
//  Created by Thisisme Hi on 2022/04/01.
//

import Foundation
import UIKit

protocol ReusableViewProtocol {
    static var identifier: String { get }
}

extension UIViewController: ReusableViewProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: ReusableViewProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableViewProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}

protocol SendNicknameDelegate: AnyObject {
    func sendNickname(_ nickname: String)
}

protocol SendCategoryDelegate: OnboardingViewController {
    func sendCategory(joke: Bool, compliment: Bool, condolence: Bool, scolding: Bool)
}

protocol SendAlarmTimeDelegate: OnboardingViewController {
    func sendAlarmTime(morning: Bool, afternoon: Bool, night: Bool)
}
