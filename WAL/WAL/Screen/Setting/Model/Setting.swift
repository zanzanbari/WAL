//
//  Setting.swift
//  WAL
//
//  Created by heerucan on 2022/05/08.
//

import Foundation

struct Setting {
    var menu: String
    var subMenu: String?
    
    init(menu: String, subMenu: String? = nil) {
        self.menu = menu

        if let subMenu = subMenu {
            self.subMenu = subMenu
        }
    }
}

// MARK: - 탈퇴뷰에 사용되는 모델

struct ResignSetting {
    var menu: String
    var select: Bool
    
    init(menu: String, select: Bool) {
        self.menu = menu
        self.select = select
    }
}

struct SettingData {
    var firstRowData = [
        Setting(menu: "알림"),
        Setting(menu: "왈소리 유형")
    ]
    
    var secondRowData = [
        Setting(menu: "왈이 궁금해요"),
        Setting(menu: "공지사항"),
        Setting(menu: "서비스 이용 약관"),
        Setting(menu: "버전 정보", subMenu: "1.0")
    ]
    
    var resignRowData = [
        ResignSetting(menu: "왈소리가 마음에 들지 않아요", select: false),
        ResignSetting(menu: "새로운 계정을 만들고 싶어요", select: false),
        ResignSetting(menu: "개인 정보를 보호하고 싶어요", select: false),
        ResignSetting(menu: "사용 빈도수가 적어요", select: false)
    ]
    
    var mypageRowData = [
        Setting(menu: "로그아웃"),
        Setting(menu: "왈 탈퇴")
    ]
    
    func getSettingCount(_ data: [Setting]) -> Int {
        return data.count
    }
    
    func getMenuLabel(_ data: [Setting], _ index: Int) -> String {
        return data[index].menu
    }
    
    func getSubMenuLabel(_ data: [Setting], _ index: Int) -> String? {
        return data[index].subMenu
    }
    
    func getResignSettingCount(_ data: [ResignSetting]) -> Int {
        return data.count
    }
    
    func getResignMenuLabel(_ data: [ResignSetting], _ index: Int) -> String {
        return data[index].menu
    }
    
    func getCheckButton(_ data: [ResignSetting], _ index: Int) -> Bool {
        return data[index].select
    }
}
