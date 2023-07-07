//
//  ViewControllerFactory.swift
//  NYT-Test
//
//  Created by Ангеліна Семенченко on 03.07.2023.
//

import Foundation

final class VCFactory {
    static var currentBooksInteractor: BooksInteractorProtocol?
    
    static func createCategoriesController() -> CategoriesTableViewController {
        let interactor = CategoriesInteractor(networkingWorker: NetworkingWorker.shared)
        let presenter = CategoriesPresenter(interactor: interactor)
        let viewController = CategoriesTableViewController(presenter: presenter)
        let router = CategoriesRouter(categoriesViewController: viewController)
        
        viewController.setRouter(router)
        presenter.viewController = viewController
        
        return viewController
    }
    
    static func createBooksController(for category: Category) -> BooksCollectionViewController {
        let interactor = BooksInteractor(category: category, networkingWorker: NetworkingWorker.shared)
        let presenter = BooksPresenter(interactor: interactor)
        let viewController = BooksCollectionViewController(presenter: presenter)
        let router = BooksRouter(booksViewController: viewController)
        
        viewController.setRouter(router)
        viewController.setSelectedCategory(category)
        presenter.viewController = viewController
        currentBooksInteractor = interactor
        
        return viewController
    }
    
    static func createBookDetailsController(book: Book) -> BookDetailsViewController {
        guard let booksInteractor = currentBooksInteractor else {
            fatalError("Must create books controller before book details controller")
        }
        
        let bookDetailsInteractor = BookDetailsInteractor(id: book.id, booksInteractor: booksInteractor)
        let presenter = BookDetailsPresenter(interactor: bookDetailsInteractor)
        let viewController = BookDetailsViewController(presenter: presenter)
        
        presenter.viewController = viewController
        
        return viewController
    }
}
