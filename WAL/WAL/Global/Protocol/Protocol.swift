//
//  Protocol.swift
//  WAL
//
//  Created by Thisisme Hi on 2022/04/01.
//

import Foundation

protocol SendCategoryDelegate: OnboardingViewController {
    func sendCategory(joke: Bool, compliment: Bool, condolence: Bool, scolding: Bool)
}

protocol SendAlarmTimeDelegate: OnboardingViewController {
    func sendAlarmTime(morning: Bool, launch: Bool, evening: Bool)
}
