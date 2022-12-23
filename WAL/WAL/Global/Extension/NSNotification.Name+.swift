//
//  NSNotification.Name+.swift
//  WAL
//
//  Created by heerucan on 2022/08/20.
//

import Foundation

extension NSNotification.Name {
    static let changeNickname = NSNotification.Name("changeNickname")
    static let fcmToken = Notification.Name("FCMToken")
    static let renewToken = Notification.Name("renewToken")
    
    static let enterMain = NSNotification.Name("EnterMain")
}
