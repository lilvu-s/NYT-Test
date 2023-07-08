//
//  CategoriesRouter.swift
//  NYT-Test
//
//  Created by Ангеліна Семенченко on 04.07.2023.
//

import Foundation

protocol BooksRouterProtocol {
    func navigateToBookDetails(book: Book)
}

final class BooksRouter: BooksRouterProtocol {
    weak var booksViewController: BooksCollectionViewControllerProtocol?
    
    init(booksViewController: BooksCollectionViewControllerProtocol) {
        self.booksViewController = booksViewController
    }
    
    func navigateToBookDetails(book: Book) {
        guard let viewController = booksViewController else {
            return
        }
        
        let bookDetailsViewController = VCFactory.createBookDetailsController(book: book)
        viewController.navigationController?.present(bookDetailsViewController, animated: true)
    }
}
