//
//  CategoriesRouter.swift
//  NYT-Test
//
//  Created by Ангеліна Семенченко on 04.07.2023.
//

import Foundation

protocol CategoriesRouterProtocol: AnyObject {
    func navigateToBooks(for category: Category)
}

final class CategoriesRouter: CategoriesRouterProtocol {
    weak var viewController: BooksCollectionViewControllerProtocol?
    
    init(viewController: BooksCollectionViewControllerProtocol) {
        self.viewController = viewController
    }
    
    func navigateToBooks(for category: Category) {
        guard let viewController = viewController else {
            return
        }
        
        let booksViewController = VCFactory.createBooksController(for: category)
        viewController.navigationController?.pushViewController(booksViewController, animated: true)
    }
}
