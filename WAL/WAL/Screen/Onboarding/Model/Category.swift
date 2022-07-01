//
//  Category.swift
//  WAL
//
//  Created by heerucan on 2022/05/07.
//

import UIKit

import WALKit

struct Category {
    var title: String
    var image: UIImage
    var subtitle: String
    var backgroundImage: UIImage
    
    init(_ title: String, _ image: UIImage, _ subtitle: String, _ backgroundImage: UIImage) {
        self.title = title
        self.image = image
        self.subtitle = subtitle
        self.backgroundImage = backgroundImage
    }
}

struct CardData {
    let cardData = [
        Category("드립", WALIcon.imgWallbbongFun.image,
                 "바나나가 웃으면? 바나나킥\n사과가 웃으면? 풋사과",
                 WALIcon.imgDripInActive.image),
        Category("주접", WALIcon.imgWallbbongLove.image,
                 "너 진짜 답없다.\n문제가 없으니까 뽀뽀쪽",
                 WALIcon.imgJujeopInActive.image),
        Category("위로", WALIcon.imgWallbbongCheer.image,
                 "지금도 잘하고 있으니까\n너무 조급해하지말자",
                 WALIcon.imgWeroInActive.image),
        Category("꾸중", WALIcon.imgWallbbongAngry.image,
                 "일어나자 일어나야지\n오늘도 누워있으면 어떡해",
                 WALIcon.imgGgujungInActive.image)
    ]
    
    func getCardCount() -> Int {
        return cardData.count
    }
    
    func getCardLabel(index: Int) -> String {
        return cardData[index].title
    }
    
    func getCardSubLabel(index: Int) -> String {
        return cardData[index].subtitle
    }
    
    func getWallbbongImage(index: Int) -> UIImage {
        return cardData[index].image
    }
    
    func getCardImage(index: Int) -> UIImage {
        return cardData[index].backgroundImage
    }
}
