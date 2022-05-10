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
        Category("드립", WALIcon.imgWallbbongFun.image, "드립어쩌구저쩌구", WALIcon.imgDripInActive.image),
        Category("주접", WALIcon.imgWallbbongLove.image, "주접어쩌구저쩌구", WALIcon.imgJujeopInActive.image),
        Category("위로", WALIcon.imgWallbbongCheer.image, "위로어쩌구저쩌구", WALIcon.imgWeroInActive.image),
        Category("꾸중", WALIcon.imgWallbbongAngry.image, "꾸중어쩌구저쩌구", WALIcon.imgGgujungInActive.image)
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
