//
//  ImageLoaderManager.swift
//  NYT-Test
//
//  Created by Ангеліна Семенченко on 06.07.2023.
//

import Alamofire
import UIKit

final class ImageLoader {
    static let shared = ImageLoader()
    private let imageCache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func loadImage(from url: URL) async throws -> UIImage {
        let cacheKey = url.absoluteString as NSString
        
        if let cachedImage = imageCache.object(forKey: cacheKey) {
            return cachedImage
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            return UIImage()
        }
        
        imageCache.setObject(image, forKey: cacheKey)
        return image
    }
}

