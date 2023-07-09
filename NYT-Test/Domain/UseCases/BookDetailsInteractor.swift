//
//  BookDetailsInteractor.swift
//  NYT-Test
//
//  Created by Ангеліна Семенченко on 06.07.2023.
//

import Alamofire
import UIKit

protocol BookDetailsInteractorProtocol: AnyObject {
    func loadBookDetails() async throws -> Book
}

final class BookDetailsInteractor: BookDetailsInteractorProtocol {
    private let booksInteractor: BooksInteractorProtocol
    let id: String
    
    init(id: String, booksInteractor: BooksInteractorProtocol) {
        self.id = id
        self.booksInteractor = booksInteractor
    }
    
    func loadBookDetails() async throws -> Book {
        let book = try await booksInteractor.loadBookDetails(id: id)
        return book
    }
    
    func loadBookCover()  async throws -> UIImage {
        let image = try await booksInteractor.loadBookCover(id: id)
        return image
    }
    
    func loadImages() async throws -> UIImage {
        let images = try await booksInteractor.loadImages()
        
        guard let image = images[id] else {
            throw ImageLoaderError.imageNotFound
        }
        
        return image
    }
}
