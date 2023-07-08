//
//  BookDetailsPresenter.swift
//  NYT-Test
//
//  Created by Ангеліна Семенченко on 06.07.2023.
//

import Foundation

protocol BookDetailsPresenterProtocol: AnyObject {
    func fetchBookDetails()
    func fetchBookCover()
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
    
    func fetchBookCover() {
        Task {
            do {
                let image = try await interactor.loadImage()
                
                DispatchQueue.main.async { [weak self] in
                    self?.viewController?.updateWithBookCover(image: image)
                }
            } catch {
                print("Error fetching book cover: \(error)")
            }
        }
    }
}

