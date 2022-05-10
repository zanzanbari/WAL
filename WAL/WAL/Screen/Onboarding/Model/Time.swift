//
//  TimeModel.swift
//  WAL
//
//  Created by heerucan on 2022/05/07.
//

import UIKit

import WALKit

struct Time {
    var time: String
    var image: UIImage
    
    init(_ time: String, _ image: UIImage) {
        self.time = time
        self.image = image
    }
}

struct TimeData {
    let timeData = [Time("아침", WALIcon.icnMorning.image),
                    Time("점심", WALIcon.icnLaunch.image),
                    Time("저녁", WALIcon.icnEvening.image)]
    
    func getTimeCount() -> Int {
        return timeData.count
    }
    
    func getTimeLabel(index: Int) -> String {
        return timeData[index].time
    }
    
    func getTimeImage(index: Int) -> UIImage {
        return timeData[index].image
    }
}
