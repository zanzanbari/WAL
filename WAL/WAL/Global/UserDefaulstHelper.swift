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
    
    var fcmtoken: [String: Any]? {
        get {
            return userDefaults.dictionary(forKey: Key.fcmtoken) ?? ["": ""]
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
    
}
