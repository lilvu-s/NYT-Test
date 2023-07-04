//
//  ViewControllerFactory.swift
//  NYT-Test
//
//  Created by Ангеліна Семенченко on 03.07.2023.
//

import Foundation

final class VCFactory {
    static func createCategoriesController() -> CategoriesTableViewController {
        let interactor = CategoriesInteractor(networkingWorker: NetworkingWorker.shared)
        let presenter = CategoriesPresenter(interactor: interactor)
        let viewController = CategoriesTableViewController(presenter: presenter)
        
        presenter.viewController = viewController
        
        return viewController
    }
    
    static func createBooksController(for category: Category) -> BooksCollectionViewController {
        let interactor = BooksInteractor(networkingWorker: NetworkingWorker.shared)
        let presenter = BooksPresenter(interactor: interactor)
        let viewController = BooksCollectionViewController(category: category, presenter: presenter)
        let router = CategoriesRouter(viewController: viewController)
        
        viewController.setRouter(router)
        presenter.viewController = viewController
        
        return viewController
    }
}
