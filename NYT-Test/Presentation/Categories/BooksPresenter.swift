//
//  BooksPresenter.swift
//  NYT-Test
//
//  Created by Ангеліна Семенченко on 04.07.2023.
//

import Foundation

protocol BooksPresenterProtocol: AnyObject {
    func fetchBooks(for category: Category)
    func didFetchBooks(_ books: [Book])
    func didFailWithError(_ error: NetworkingError)
}

final class BooksPresenter: BooksPresenterProtocol {
    weak var viewController: BooksCollectionViewControllerProtocol?
    private let interactor: BooksInteractorProtocol
    
    init(interactor: BooksInteractorProtocol) {
        self.interactor = interactor
    }
    
    func fetchBooks(for category: Category) {
        Task {
            do {
                let books = try await interactor.fetchBooks(for: category)
                didFetchBooks(books)
            } catch let error as NetworkingError {
                didFailWithError(error)
            } catch {
                didFailWithError(NetworkingError.unknown)
            }
        }
    }
    
    func didFetchBooks(_ books: [Book]) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.didFetchBooks(books)
        }
    }
    
    func didFailWithError(_ error: NetworkingError) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.didFailWithError(error)
        }
    }
}
