//
//  BooksInteractor.swift
//  NYT-Test
//
//  Created by Ангеліна Семенченко on 03.07.2023.
//

import Alamofire

protocol BooksInteractorProtocol: AnyObject {
    func fetchBooks(for category: Category) async throws -> [Book]
}

final class BooksInteractor: BooksInteractorProtocol {
    private let networkingWorker: NetworkingWorker
    
    init(networkingWorker: NetworkingWorker) {
        self.networkingWorker = networkingWorker
    }
    
    func fetchBooks(for category: Category) async throws -> [Book] {
        do {
            let books = try await networkingWorker.fetchBooks(for: category.listNameEncoded)
            return books
        } catch let error as AFError {
            throw ErrorHandler.handleRequestError(error)
        }
    }
}
