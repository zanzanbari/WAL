//
//  Time.swift
//  WAL
//
//  Created by heerucan on 2022/06/01.
//

import UIKit
import WALKit

struct Time {
    var time: String
    var image: UIImage
    
    init(time: String, image: UIImage) {
        self.time = time
        self.image = image
    }
}

struct TimeData {
    var timeData = [Time(time: "아침", image: WALIcon.icnMorning.image),
                    Time(time: "점심", image: WALIcon.icnLaunch.image),
                    Time(time: "저녁", image: WALIcon.icnEvening.image)]
    
    func getTimeLabel(index: Int) -> String {
        return timeData[index].time
    }
    
    func getTimeImage(index: Int) -> UIImage {
        return timeData[index].image
    }
}
