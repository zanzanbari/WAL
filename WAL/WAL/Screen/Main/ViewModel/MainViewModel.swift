//
//  MainViewModel.swift
//  WAL
//
//  Created by 소연 on 2023/01/25.
//

import Foundation

import RxCocoa
import RxSwift

final class MainViewModel {
    func saveImageOnPhone(image: UIImage, image_name: String) -> URL? {
        let imagePath: String = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(image_name).png"
        let imageUrl: URL = URL(fileURLWithPath: imagePath)
        
        do {
            try image.pngData()?.write(to: imageUrl)
            return imageUrl
        } catch {
            return nil
        }
    }
}
