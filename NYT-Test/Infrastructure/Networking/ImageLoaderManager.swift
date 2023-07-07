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
    
    private init() {}
    
    func loadImage(from url: URL) async throws -> UIImage {
        return try await withCheckedThrowingContinuation { continuation in
            AF.download(url).responseData { response in
                switch response.result {
                case .success(let data):
                    if let image = UIImage(data: data) {
                        continuation.resume(returning: image)
                    } else {
                        continuation.resume(throwing: ImageLoadingError.invalidImageData)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

enum ImageLoadingError: Error {
    case invalidImageData
}

