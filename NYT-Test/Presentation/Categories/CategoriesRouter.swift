//
//  CategoriesRouter.swift
//  NYT-Test
//
//  Created by Ангеліна Семенченко on 06.07.2023.
//

import Foundation

protocol CategoriesRouterProtocol: AnyObject {
    func navigateToBooksList(for category: Category)
}

final class CategoriesRouter: CategoriesRouterProtocol {
    weak var categoriesViewController: CategoriesTableViewControllerProtocol?
    
    init(categoriesViewController: CategoriesTableViewControllerProtocol) {
        self.categoriesViewController = categoriesViewController
    }
    
    func navigateToBooksList(for category: Category) {
        guard let viewController = categoriesViewController else {
            return
        }
        
        let booksViewController = VCFactory.createBooksController(for: category)
        viewController.navigationController?.pushViewController(booksViewController, animated: true)
    }
}

