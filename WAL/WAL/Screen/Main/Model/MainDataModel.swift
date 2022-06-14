//
//  TempModel.swift
//  WAL
//
//  Created by Thisisme Hi on 2022/04/01.
//

import UIKit

import WALKit

enum WALDataType {
    case morning
    case lunch
    case evening
    case speacial
    
    var image: UIImage {
        switch self {
        case .morning, .lunch, .evening:
            return WALIcon.imgPawActive.image
        case .speacial:
            return WALIcon.imgPawSpecial.image
        }
    }
    
    var color: UIColor {
        switch self {
        case .morning, .lunch, .evening:
            return UIColor.orange100
        case .speacial:
            return UIColor.orange100
        }
    }
}

struct MainDataModel: Codable {
    let type, walType, content: String
    let canOpen: Bool
}

extension MainDataModel {
    static let mainData: [MainDataModel] = [
        MainDataModel(type: "아침", walType: "드립", content: "후회할거면 그렇게 살지 말고,\n그렇게 살거면 후....후 불면은 구멍이 뚫리는\n커다란 솜 사 탕", canOpen: true),
        MainDataModel(type: "스페셜", walType: "스페셜", content: "너는 진돗개한테 물려야 돼", canOpen: true),
        MainDataModel(type: "점심", walType: "꾸중", content: "얌마 쫘샤 뭐하는거야 정신 안차려?\n너 더 열심히 살 수 있는 사람이잖아\n왜 빈둥거려", canOpen: true),
        MainDataModel(type: "저녁", walType: "주접", content: "오늘 우체국에서 한바탕 했어\n너에게 내 사랑을 담아 보내려고했는데\n그정도 크기의 박스는 없대", canOpen: false)
    ]
}
