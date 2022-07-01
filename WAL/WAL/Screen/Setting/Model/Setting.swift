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

struct SettingData {
    var firstRowData = [
        Setting(menu: "알림"),
        Setting(menu: "왈소리 유형")
    ]
    
    var secondRowData = [
        Setting(menu: "왈이 궁금해요"),
        Setting(menu: "공지사항"),
        Setting(menu: "의견 보내기"),
        Setting(menu: "서비스 이용 약관"),
        Setting(menu: "개인정보처리방침"),
        Setting(menu: "오픈소스 라이선스"),
        Setting(menu: "버전", subMenu: "1.0")
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
}
