//
//  NYTWorker.swift
//  NYT-Test
//
//  Created by Ангеліна Семенченко on 03.07.2023.
//

import Foundation
import Alamofire

final class NetworkingWorker {
    private let apiKey: String
    
    init() {
        guard let apiKey = ProcessInfo.processInfo.environment["API_KEY"] else {
            fatalError("API_KEY not found in environment")
        }
        self.apiKey = apiKey
    }
    
    func fetchCategories(completion: @escaping ([Category]) -> Void) {
        let url = "https://api.nytimes.com/svc/books/v3/lists/names.json?api-key=\(apiKey)"
        
        AF.request(url).responseDecodable(of: CategoriesResponse.self) { response in
            switch response.result {
            case .success(let categoriesResponse):
                completion(categoriesResponse.results)
            case .failure(let error):
                ErrorHandler.handleRequestError(error)
                completion([])
            }
        }
    }
    
    func fetchBooks(for category: String, completion: @escaping ([Book]) -> Void) {
        let url = "https://api.nytimes.com/svc/books/v3/lists/current/\(category).json?api-key=\(apiKey)"
        
        AF.request(url).responseDecodable(of: BooksResponse.self) { response in
            switch response.result {
            case .success(let booksResponse):
                let books = booksResponse.results.flatMap { $0.books }
                completion(books)
            case .failure(let error):
                ErrorHandler.handleRequestError(error)
                completion([])
            }
        }
    }
}
