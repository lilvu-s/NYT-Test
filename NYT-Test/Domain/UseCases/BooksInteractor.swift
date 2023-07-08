//
//  BooksInteractor.swift
//  NYT-Test
//
//  Created by Ангеліна Семенченко on 03.07.2023.
//

import Alamofire
import UIKit

protocol BooksInteractorProtocol: AnyObject {
    func fetchBooks() async throws -> [Book]
    func loadBookDetails(id: String) async throws -> Book
    func loadImages() async throws -> [String: UIImage]
    func loadBooksFromRealm() -> [Book]
    func loadImagesFromRealm() -> [String: UIImage]
    func loadBookCover(id: String) async throws -> UIImage
}

final class BooksInteractor: BooksInteractorProtocol {
    private let networkingWorker: NetworkingWorker
    private let realmManager: RealmManager
    var books: [Book] = []
    let category: Category
    
    init(category: Category, networkingWorker: NetworkingWorker, realmManager: RealmManager) {
        self.category = category
        self.networkingWorker = networkingWorker
        self.realmManager = realmManager
    }
    
    func fetchBooks() async throws -> [Book] {
        if networkingWorker.isConnectedToInternet() {
            books = try await networkingWorker.fetchBooks(for: category.listNameEncoded)
            let realmBooks = books.map { convertBookToRealmBook($0) }
            
            print("Before saving books to Realm: \(realmBooks.count)")
            realmManager.saveBooks(realmBooks)
            print("After saving books to Realm: \(realmBooks.count)")
        } else {
            let realmBooks = realmManager.getAllBooks(for: category.listNameEncoded)
            
            if let realmBooks = realmBooks, !realmBooks.isEmpty {
                books = realmBooks.map { convertRealmBookToBook($0) }
                
                print("After loading books from Realm: \(books.count)")
            } else {
                print("No books found in Realm.")
            }
        }
        return books
    }
    
    func loadBookDetails(id: String) async throws -> Book {
        if networkingWorker.isConnectedToInternet() {
            guard let book = books.first(where: { $0.id == id }) else {
                throw BookLoaderError.bookNotFound
            }
            return book
        } else {
            if let book = realmManager.getBook(with: id) {
                return convertRealmBookToBook(book)
            } else {
                throw BookLoaderError.bookNotFound
            }
        }
    }
    
    func loadBookCover(id: String) async throws -> UIImage {
        if networkingWorker.isConnectedToInternet() {
            guard let book = books.first(where: { $0.id == id }),
                  let imageURL = book.bookImage else {
                throw BookLoaderError.bookNotFound
            }
            
            do {
                let image = try await ImageLoader.shared.loadImage(from: imageURL)
                
                let imageData = image.jpegData(compressionQuality: 1.0)?.base64EncodedString()
                realmManager.updateBookImageData(bookId: book.id, imageData: imageData)
                return image
            } catch {
                throw ImageLoaderError.imageLoadFailed
            }
            
        } else {
            if let imageDataString = realmManager.getBook(with: id)?.bookImage,
               let imageData = Data(base64Encoded: imageDataString),
               let image = UIImage(data: imageData) {
                return image
            } else {
                throw ImageLoaderError.imageLoadFailed
            }
        }
    }
    
    func loadImages() async throws -> [String: UIImage] {
        var images: [String: UIImage] = [:]
        
        if networkingWorker.isConnectedToInternet() {
            for book in books {
                guard let imageURL = book.bookImage else { continue }
                print("Loading image for book \(book.title): \(imageURL)")
                
                do {
                    let image = try await ImageLoader.shared.loadImage(from: imageURL)
                    images[book.id] = image
                    
                    let imageData = image.jpegData(compressionQuality: 1.0)?.base64EncodedString()
                    realmManager.updateBookImageData(bookId: book.id, imageData: imageData)
                } catch {
                    print("Failed to load image for book \(book.title): \(error)")
                }
                
                print("Image loaded for book \(book.title)")
            }
        } else {
            for book in books {
                guard let imageDataString = realmManager.getBook(with: book.id)?.bookImage,
                      let imageData = Data(base64Encoded: imageDataString),
                      let image = UIImage(data: imageData) else {
                    throw ImageLoaderError.invalidImageData
                }
                images[book.id] = image
            }
        }
        return images
    }
    
    func loadBooksFromRealm() -> [Book] {
        guard let realmBooks = realmManager.getAllBooks(for: category.listNameEncoded) else {
            return []
        }
        return Array(realmBooks).map { convertRealmBookToBook($0) }
    }
    
    func loadImagesFromRealm() -> [String: UIImage] {
        guard let realmImages = realmManager.getAllBookImages() else {
            return [:]
        }
        var images: [String: UIImage] = [:]
        for realmImage in realmImages {
            if let imageDataString = realmImage.bookImage,
               let imageData = Data(base64Encoded: imageDataString),
               let image = UIImage(data: imageData) {
                images[realmImage.id] = image
            }
        }
        return images
    }
}

extension BooksInteractor {
    private func convertBookToRealmBook(_ book: Book) -> BookRealm {
        let realmBook = BookRealm()
        realmBook.id = book.id
        realmBook.category = category.listNameEncoded
        realmBook.rank = book.rank
        realmBook.title = book.title
        realmBook.author = book.author
        realmBook.publisher = book.publisher
        realmBook.bookImage = book.bookImage?.absoluteString
        realmBook.bookDescription = book.description
        
        book.buyLinks.forEach { buyLink in
            let realmBuyLink = BuyLinkRealm()
            realmBuyLink.name = buyLink.name
            realmBuyLink.url = buyLink.url.absoluteString
            realmBook.buyLinks.append(realmBuyLink)
        }
        
        return realmBook
    }
    
    private func convertRealmBookToBook(_ realmBook: BookRealm) -> Book {
        let book = Book(
            rank: realmBook.rank,
            title: realmBook.title,
            description: realmBook.bookDescription,
            author: realmBook.author,
            publisher: realmBook.publisher,
            bookImage: URL(string: realmBook.bookImage ?? ""),
            buyLinks: realmBook.buyLinks.compactMap { buyLink in
                if let url = URL(string: buyLink.url) {
                    return Book.BuyLink(name: buyLink.name, url: url)
                }
                return nil
            }
        )
        return book
    }
}
