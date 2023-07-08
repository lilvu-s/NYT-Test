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
    
    func loadImage() async throws -> UIImage {
        let images = try await booksInteractor.loadImages()
        let book = try await loadBookDetails()
        
        guard let image = images[book.id] else {
            throw ImageLoaderError.imageNotFound
        }
        
        return image
    }
}
