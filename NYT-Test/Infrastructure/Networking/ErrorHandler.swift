//
//  ErrorHandler.swift
//  NYT-Test
//
//  Created by Ангеліна Семенченко on 03.07.2023.
//

import Alamofire

final class ErrorHandler {
    static func handleRequestError(_ error: AFError) -> NetworkingError {
        switch error {
        case .sessionTaskFailed(let error):
            print("Session task failed with error: \(error)")
            return NetworkingError.sessionTaskFailed
        case .invalidURL(let url):
            print("Invalid URL: \(url)")
            return NetworkingError.invalidURL
        case .responseValidationFailed(let reason):
            print("Response validation failed with reason: \(reason)")
            return NetworkingError.responseValidationFailed
        case .responseSerializationFailed(let reason):
            print("Response serialization failed with reason: \(reason)")
            return NetworkingError.responseSerializationFailed
        default:
            print("Request failed with error: \(error)")
            return NetworkingError.unknown
        }
    }
    
    static func handlerBookLoaderError(_ error: Error) -> BookLoaderError {
        if let error = error as? BookLoaderError {
            switch error {
            case .bookNotFound:
                print("Book not found")
                return .bookNotFound
            case .indexOutOfRange:
                print("Index out of range")
                return .indexOutOfRange
            case .invalidImageData:
                print("Invalid image data")
                return .invalidImageData
            default:
                print("Unknown book loader error")
                return .unknown
            }
        } else {
            print("Unknown error")
            return .unknown
        }
    }
}

enum NetworkingError: Error {
    case sessionTaskFailed
    case invalidURL
    case responseValidationFailed
    case responseSerializationFailed
    case requestFailed
    case rateLimitExceeded
    case unknown
}

enum BookLoaderError: Error {
    case bookNotFound
    case indexOutOfRange
    case invalidImageData
    case unknown
}
