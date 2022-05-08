//
//  HistoryResponse.swift
//  WAL
//
//  Created by 소연 on 2022/05/03.
//

import Foundation

struct HistoryDataModel {
    let reserveDate, content, recieveDate: String
    let hidden: Bool
}

extension HistoryDataModel {
    static let reserveData: [HistoryDataModel] = [
        HistoryDataModel(reserveDate: "04. 11 (월) 오후 5:00 • 전송 예정",
                         content:
        """
        고생 많았젱? 고생했다 나야 퇴근길이겠군 집 들어서가서 씻어치킨먹고싶다 케이에프씨 치킨 내일은 혼자 먹는다고 하고 앞에 치킨먹으러 가야겠다 회사앞에 있던가 없던가 기억이 잘 안나네
        """,
                         recieveDate: "2022.03.12",
                         hidden: false),
        HistoryDataModel(reserveDate: "04. 11 (월) 오후 5:00 • 전송 예정",
                         content: "난 과거에서 온 00이야 오늘하루도 고생 많았젱?",
                         recieveDate: "2022.03.12",
                         hidden: false),
        HistoryDataModel(reserveDate: "04. 11 (월) 오후 5:00 • 전송 예정",
                         content:
        """
        고생 많았젱? 고생했다 나야 퇴근길이겠군 집 들어서가서 씻어치킨먹고싶다 케이에프씨 치킨 내일은 혼자 먹는다고 하고 앞에 치킨먹으러 가야겠다 회사앞에 있던가 없던가 기억이 잘 안나네
        """,
                         recieveDate: "2022.03.12",
                         hidden: true)
    ]
    
    static let completeData: [HistoryDataModel] = [
        HistoryDataModel(reserveDate: "04. 11 (월) 오후 5:00 • 전송 예정",
                         content: "난 과거에서 온 00이야 오늘하루도 고생 많았젱?",
                         recieveDate: "2022.03.12",
                         hidden: false),
        HistoryDataModel(reserveDate: "04. 11 (월) 오후 5:00 • 전송 예정",
                         content:
        """
        고생 많았젱? 고생했다 나야 퇴근길이겠군 집 들어서가서 씻어치킨먹고싶다 케이에프씨 치킨 내일은 혼자 먹는다고 하고 앞에 치킨먹으러 가야겠다 회사앞에 있던가 없던가 기억이 잘 안나네
        """,
                         recieveDate: "2022.03.12",
                         hidden: false),
        HistoryDataModel(reserveDate: "04. 11 (월) 오후 5:00 • 전송 예정",
                         content:
        """
        고생 많았젱? 고생했다 나야 퇴근길이겠군 집 들어서가서 씻어치킨먹고싶다 케이에프씨 치킨 내일은 혼자 먹는다고 하고 앞에 치킨먹으러 가야겠다 회사앞에 있던가 없던가 기억이 잘 안나네
        """,
                         recieveDate: "2022.03.12",
                         hidden: false)
    ]
}
