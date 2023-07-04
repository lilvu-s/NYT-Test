//
//  CategoriesInteractor.swift
//  NYT-Test
//
//  Created by Ангеліна Семенченко on 03.07.2023.
//

import Alamofire

protocol CategoriesInteractorProtocol: AnyObject {
    func fetchCategories() async throws -> [Category]
}

final class CategoriesInteractor: CategoriesInteractorProtocol {
    private let networkingWorker: NetworkingWorker
    
    init(networkingWorker: NetworkingWorker) {
        self.networkingWorker = networkingWorker
    }
    
    func fetchCategories() async throws -> [Category] {
        do {
            let categories = try await networkingWorker.fetchCategories()
            return categories
        } catch let error as AFError {
            throw ErrorHandler.handleRequestError(error)
        }
    }
}
