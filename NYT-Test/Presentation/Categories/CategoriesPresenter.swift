//
//  CategoriesPresenter.swift
//  NYT-Test
//
//  Created by Ангеліна Семенченко on 04.07.2023.
//

import Foundation

protocol CategoriesPresenterProtocol: AnyObject {
    func fetchCategories()
    func didFetchCategories(_ category: [Category])
    func didFailWithError(_ error: NetworkingError)
}

final class CategoriesPresenter: CategoriesPresenterProtocol {    
    weak var viewController: CategoriesTableViewControllerProtocol?
    private let interactor: CategoriesInteractorProtocol
    
    init(interactor: CategoriesInteractorProtocol) {
        self.interactor = interactor
    }
    
    func fetchCategories() {
        Task {
            do {
                let categories = try await interactor.fetchCategories()
                didFetchCategories(categories)
            } catch let error as NetworkingError {
                didFailWithError(error)
            } catch {
                didFailWithError(NetworkingError.unknown)
            }
        }
    }
    
    func didFetchCategories(_ category: [Category]) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.didFetchCategories(category)
        }
    }
    
    func didFailWithError(_ error: NetworkingError) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.didFailWithError(error)
        }
    }
}
