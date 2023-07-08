//
//  BooksPresenter.swift
//  NYT-Test
//
//  Created by Ангеліна Семенченко on 04.07.2023.
//

import Foundation
import UIKit

protocol BooksPresenterProtocol: AnyObject {
    func fetchBooks()
    func didFetchBooks(_ books: [Book])
    func didFetchImages(_ images: [String: UIImage])
    func didFailWithError(_ error: NetworkingError)
}

final class BooksPresenter: BooksPresenterProtocol {
    weak var viewController: BooksCollectionViewControllerProtocol?
    let interactor: BooksInteractor
    
    init(interactor: BooksInteractor) {
        self.interactor = interactor
    }
    
    func fetchBooks() {
        Task {
            do {
                let books = try await interactor.fetchBooks()
                let images = try await interactor.loadImages()
                
                didFetchBooks(books)
                didFetchImages(images)
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
    
    func didFetchImages(_ images: [String: UIImage]) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.didFetchImages(images)
        }
    }
    
    func didFailWithError(_ error: NetworkingError) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.didFailWithError(error)
        }
    }
}
