//
//  CoreDataModel.swift
//  BCD
//
//  Created by Liuliet.Lee on 13/7/2017.
//  Copyright © 2017 Liuliet.Lee. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import ImageIO

class CoreDataModel {
    let context = CoreDataStorage.sharedInstance.mainQueueContext
   
    static let context = CoreDataStorage.sharedInstance.mainQueueContext

    func saveContext() {
        CoreDataStorage.sharedInstance.saveContext(context)
    }
    
    static func saveContext() {
        CoreDataStorage.sharedInstance.saveContext(context)
    }
}

extension CGSize {
    static let coverThumnailSize = CGSize(width: 125, height: 78)
}

extension UIImage {
    func data() -> Data {
        return pngData()!
    }
    
    func resized(to size: CGSize = .coverThumnailSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { (ctx) in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

extension Data {
    func toImage(sized size: CGSize = .coverThumnailSize) -> UIImage? {
        let scale = UIScreen.main.scale
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceThumbnailMaxPixelSize: Swift.max(size.width, size.height) * scale
        ]

        guard let imageSource = CGImageSourceCreateWithData(self as CFData, nil),
            let image = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary)
        else {
            return nil
        }

        return UIImage(cgImage: image, scale: scale, orientation: .up)
    }
}

extension String {
    var isGIF: Bool {
        return hasSuffix("gif")
    }
}
