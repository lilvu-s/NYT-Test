//
//  CategoriesInteractor.swift
//  NYT-Test
//
//  Created by Ангеліна Семенченко on 03.07.2023.
//

import Alamofire

protocol CategoriesInteractorProtocol: AnyObject {
    func fetchCategories() async throws -> [Category]
    func loadCategoriesFromRealm() -> [Category]
}

final class CategoriesInteractor: CategoriesInteractorProtocol {
    private let networkingWorker: NetworkingWorker
    private let realmManager: RealmManager
    
    init(networkingWorker: NetworkingWorker, realmManager: RealmManager) {
        self.networkingWorker = networkingWorker
        self.realmManager = realmManager
    }
    
    func fetchCategories() async throws -> [Category] {
        if networkingWorker.isConnectedToInternet() {
            do {
                let categories = try await networkingWorker.fetchCategories()
                let realmCategories = categories.map { convertCategoryToRealmCategory($0) }
                realmManager.saveCategories(realmCategories)
                return categories
            } catch let error as AFError {
                throw ErrorHandler.handleRequestError(error)
            }
        } else {
            let realmCategories = realmManager.getAllCategories()
            if let realmCategories = realmCategories {
                let categories = realmCategories.map { self.convertRealmCategoryToCategory($0) }
                return Array(categories)
            }
        }
        return [Category]()
    }
    
    func loadCategoriesFromRealm() -> [Category] {
        guard let realmCategories = realmManager.getAllCategories() else {
            return []
        }
        return Array(realmCategories).map { convertRealmCategoryToCategory($0) }
    }
}

extension CategoriesInteractor {
    func convertRealmCategoryToCategory(_ realmCategory: CategoryRealm) -> Category {
        let category = Category(
            name: realmCategory.name,
            newestPublishedDate: realmCategory.newestPublishedDate,
            listNameEncoded: realmCategory.listNameEncoded
        )
        return category
    }
    
    func convertCategoryToRealmCategory(_ category: Category) -> CategoryRealm {
        let realmCategory = CategoryRealm()
        realmCategory.name = category.name
        realmCategory.newestPublishedDate = category.newestPublishedDate
        realmCategory.listNameEncoded = category.listNameEncoded
        return realmCategory
    }
}

