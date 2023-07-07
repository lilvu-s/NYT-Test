//
//  BookDetailsPresenter.swift
//  NYT-Test
//
//  Created by Ангеліна Семенченко on 06.07.2023.
//

import Foundation

protocol BookDetailsPresenterProtocol: AnyObject {
    func fetchBookDetails()
//    func fetchBookCover(for book: Book)
}

class BookDetailsPresenter: BookDetailsPresenterProtocol {
    weak var viewController: BookDetailsViewControllerProtocol?
    var interactor: BookDetailsInteractor
    
    init(interactor: BookDetailsInteractor) {
        self.interactor = interactor
    }
    
    func fetchBookDetails() {
        Task {
            do {
                let book = try await interactor.loadBookDetails()
                
                viewController?.updateWithBookDetails(book: book)
            } catch {
                print("Error fetching book details: \(error)")
            }
        }
    }
    /* TODO: Loading image

    func fetchBookCover(for book: Book) {
        Task {
            do {
                let coverImage = try await interactor.loadBookCover(book: book)
                print("Book cover fetched in presenter")
                viewController?.updateWithBookCover(image: coverImage)
            } catch {
                print("Error fetching book cover: \(error)")
            }
        }
    }
    */
}

