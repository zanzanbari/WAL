//
//  UserDefaulstHelper.swift
//  WAL
//
//  Created by heerucan on 2022/09/26.
//

import Foundation

final class UserDefaultsHelper {
    private init() { }
    static let standard = UserDefaultsHelper()
    
    let userDefaults = UserDefaults.standard
    
    enum Key {
        static let accesstoken = "accesstoken"
        static let refreshtoken = "refreshtoken"
        static let socialtoken = "socialtoken"
        static let social = "social"
        static let fcmtoken = "fcmtoken"
        static let nickname = "nickname"
        static let complete = "complete"
        static let pushNoti = "toggle"
        static let email = "email"
    }
    
    var accesstoken: String? {
        get {
            return userDefaults.string(forKey: Key.accesstoken) ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: Key.accesstoken)
        }
    }
    
    var refreshtoken: String? {
        get {
            return userDefaults.string(forKey: Key.refreshtoken) ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: Key.refreshtoken)
        }
    }
    
    var socialtoken: String? {
        get {
            return userDefaults.string(forKey: Key.socialtoken) ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: Key.socialtoken)
        }
    }
    
    var social: String? {
        get {
            return userDefaults.string(forKey: Key.social) ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: Key.social)
        }
    }
    
    var fcmtoken: String? {
        get {
            return userDefaults.string(forKey: Key.fcmtoken)
        }
        set {
            userDefaults.set(newValue, forKey: Key.fcmtoken)
        }
    }
    
    var nickname: String? {
        get {
            return userDefaults.string(forKey: Key.nickname) ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: Key.nickname)
        }
    }
    
    var email: String? {
        get {
            return userDefaults.string(forKey: Key.email) ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: Key.email)
        }
    }
    
    // default 값이 false임 설정을 따로 안해주면
    var complete: Bool {
        get {
            return userDefaults.bool(forKey: Key.complete)
        }
        set {
            userDefaults.set(newValue, forKey: Key.complete)
        }
    }
    
    var pushNoti: Bool {
        get {
            return userDefaults.bool(forKey: Key.pushNoti)
        }
        set {
            userDefaults.set(newValue, forKey: Key.pushNoti)
        }
    }
    
    func removeObject() {
        userDefaults.removeObject(forKey: Key.accesstoken)
        userDefaults.removeObject(forKey: Key.refreshtoken)
        userDefaults.removeObject(forKey: Key.socialtoken)
        userDefaults.removeObject(forKey: Key.social)
        userDefaults.removeObject(forKey: Key.nickname)
        userDefaults.removeObject(forKey: Key.complete)
        userDefaults.removeObject(forKey: Key.pushNoti)
        userDefaults.removeObject(forKey: Key.email)
    }
    
    // 로그아웃을 위해
    func removeAccessToken() {
        userDefaults.removeObject(forKey: Key.accesstoken)
    }
}
