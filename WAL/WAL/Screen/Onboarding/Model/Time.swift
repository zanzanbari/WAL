//
//  TimeModel.swift
//  WAL
//
//  Created by heerucan on 2022/05/07.
//

import UIKit

import WALKit

// TODO: - 온보딩 세팅에서 해당 내용 수정하고 이 파일 버릴 것
struct Time {
    var time: String
    var image: UIImage
    
    init(_ time: String, _ image: UIImage) {
        self.time = time
        self.image = image
    }
}

struct TimeData {
    func getTimeCount() -> Int {
        return 3
    }
    
    func getTimeLabel(index: Int) -> String {
        return AlarmTimeType.allCases[index].kor
    }
    
    func getTimeImage(index: Int) -> UIImage? {
        return AlarmTimeType.allCases[index].onboardImage
    }
}
