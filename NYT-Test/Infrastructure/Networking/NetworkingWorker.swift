//
//  NYTWorker.swift
//  NYT-Test
//
//  Created by Ангеліна Семенченко on 03.07.2023.
//

import Foundation
import Alamofire

final class NetworkingWorker {
    static let shared = NetworkingWorker()
    private let apiKey: String
    private var requestCount: Int = 0
    private var requestPeriodStart: Date?
    
    private init() {
        guard let apiKey = ProcessInfo.processInfo.environment["API_KEY"] else {
            fatalError("API_KEY not found in environment")
        }
        self.apiKey = apiKey
        self.requestPeriodStart = Date()
    }
    
    func fetchCategories() async throws -> [Category] {
        let baseURL = "https://api.nytimes.com/svc/books/v3/lists"
        let path = "/names.json"
        let url = "\(baseURL)\(path)?api-key=\(apiKey)"
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url).responseDecodable(of: CategoriesResponse.self) { response in
                switch response.result {
                case .success(let categoriesResponse):
                    continuation.resume(returning: categoriesResponse.results)
                case .failure(let error):
                    continuation.resume(throwing: ErrorHandler.handleRequestError(error))
                }
            }
        }
    }
    
    func fetchBooks(for category: String) async throws -> [Book] {
        let baseURL = "https://api.nytimes.com/svc/books/v3/lists"
        let path = "/\(category).json"
        let url = "\(baseURL)\(path)?api-key=\(apiKey)"
        
        func checkRequestLimits() throws {
            if let requestPeriodStart = requestPeriodStart {
                if -requestPeriodStart.timeIntervalSinceNow >= 60 {
                    self.requestPeriodStart = Date()
                    requestCount = 0
                }
            } else {
                print("requestPeriodStart is nil")
            }
            
            if requestCount >= 5 {
                throw NetworkingError.rateLimitExceeded
            }
            requestCount += 1
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url).responseDecodable(of: BooksResponse.self) { response in
                switch response.result {
                case .success(let booksResponse):
                    do {
                        try checkRequestLimits()
                        continuation.resume(returning: booksResponse.results.books)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: ErrorHandler.handleRequestError(error))
                }
            }
        }
    }
}
