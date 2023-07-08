//
//  BooksInteractor.swift
//  NYT-Test
//
//  Created by Ангеліна Семенченко on 03.07.2023.
//

import Foundation
import Alamofire
import UIKit

protocol BooksInteractorProtocol: AnyObject {
    func fetchBooks() async throws -> [Book]
    func loadBookDetails(id: String) async throws -> Book
    func loadImages() async throws -> [String: UIImage]
}

final class BooksInteractor: BooksInteractorProtocol {
    private let networkingWorker: NetworkingWorker
    var books: [Book] = []
    let category: Category
    
    init(category: Category, networkingWorker: NetworkingWorker) {
        self.category = category
        self.networkingWorker = networkingWorker
    }
    
    func fetchBooks() async throws -> [Book] {
        do {
            books = try await networkingWorker.fetchBooks(for: category.listNameEncoded)
            
            return books
        } catch let error as AFError {
            throw ErrorHandler.handleRequestError(error)
        }
    }
    
    func loadBookDetails(id: String) async throws -> Book {
        guard let book = books.first(where: { $0.id == id }) else {
            throw BookLoaderError.bookNotFound
        }
        
        return book
    }
    
    func loadImages() async throws -> [String: UIImage] {
        var images: [String: UIImage] = [:]
        
        do {
            for book in books {
                guard let imageURL = book.bookImage else { continue }
                
                do {
                    let image = try await ImageLoader.shared.loadImage(from: imageURL)
                    images[book.id] = image
                } catch {
                    print("Failed to load image for book \(book.title): \(error)")
                }
            }
        }
        return images
    }
}
