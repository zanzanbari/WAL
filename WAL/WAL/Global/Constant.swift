//
//  Constant.swift
//  WAL
//
//  Created by heerucan on 2022/06/13.
//

import Foundation

enum Constant {
    
    enum Key {
        static let alarmToggle = "alarmToggle"
    }
    
    enum URL {
        static let walURL = "https://receptive-humidity-bf2.notion.site/WAL-cde83326689247dfabaf712245f359fe"
        static let serviceURL = "https://receptive-humidity-bf2.notion.site/3f7f92f2f8f54b63907b84b7416eb8e8"
    }
    
    enum Placeholder {
        static let warnText = "띄어쓰기 없이 한글, 영문, 숫자만 가능해요"
        static let resignText = "앱 사용에 불편함이 있으시다면 WAL 공식 톡 채널을 통해 알려주세요. 탈퇴 후 탈퇴 철회(탈퇴 취소)는 불가합니다. 탈퇴 후 회원정보 및 이용 기록은 모두 삭제되며, 다시 복구할 수 없습니다."
    }
        
    enum Toast {
        static let selectOneMore = "1개 이상 선택해주세요"
    }
    
    enum NavigationTitle {
        static let resign = "왈 탈퇴"
        static let editNick = "닉네임 수정"
        static let mypage = "내 정보"
        static let zanzan = "왈이 궁금해요"
        static let setting = "설정"
        static let settingCategory = "왈소리 유형"
        static let settingAlarm = "알림"
    }
    
    enum Login {
        static let gif = "login500"
        static let resign = "탈퇴 후 24시간 내 재가입 불가합니다."
    }
    
    enum OnboardComplete {
        static let complete = "맞춤 설정 완료"
        static let start = "시작하기"
        static let description = "님 맞춤 설정을 끝냈어요\n왈을 시작해볼까요?"
    }
    
    enum EditNickname {
        static let placeholder = "닉네임을 입력해주세요"
    }
    
    enum SettingAlarm {
        static let title = "왈소리 받는 시간"
    }
    
    enum SettingCategory {
        static let title = "받고 싶은 왈소리 유형을 선택해주세요"
        static let subtitle = "다중 선택 가능해요"
    }
    
    enum Logout {
        static let title = "로그아웃"
        static let subtitle = "정말 로그아웃 하시겠어요?"
        static let right = "로그아웃"
        static let left = "취소"
    }
    
    enum Lottie {
        static let loading = "loading"
    }
}
