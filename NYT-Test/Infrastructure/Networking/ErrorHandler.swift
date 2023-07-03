//
//  ErrorHandler.swift
//  NYT-Test
//
//  Created by Ангеліна Семенченко on 03.07.2023.
//

import Alamofire

final class ErrorHandler {
    static func handleRequestError(_ error: AFError) {
        switch error {
        case .sessionTaskFailed(let error):
            print("Session task failed with error: \(error)")
        case .invalidURL(let url):
            print("Invalid URL: \(url)")
        case .responseValidationFailed(let reason):
            print("Response validation failed with reason: \(reason)")
        case .responseSerializationFailed(let reason):
            print("Response serialization failed with reason: \(reason)")
        default:
            print("Request failed with error: \(error)")
        }
    }
}
