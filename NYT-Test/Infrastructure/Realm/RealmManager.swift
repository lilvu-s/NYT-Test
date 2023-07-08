//
//  RealmManager.swift
//  NYT-Test
//
//  Created by Ангеліна Семенченко on 08.07.2023.
//

import Foundation
import RealmSwift

class RealmManager {
    private let realm: Realm
    
    init() {
        do {
            realm = try Realm()
            let realmURL = realm.configuration.fileURL
            print("Realm database location: \(realmURL?.path ?? "Unknown")")
        } catch {
            print("Failed to initialize Realm: \(error.localizedDescription)")
            fatalError("Failed to initialize Realm")
        }
    }
    
    // MARK: - Save operations
    
    func saveCategories(_ categories: [CategoryRealm]) {
        DispatchQueue.global(qos: .background).async {
            autoreleasepool {
                do {
                    let realm = try Realm()
                    try realm.write {
                        for category in categories {
                            realm.add(category, update: .modified)
                        }
                    }
                } catch {
                    print("Failed to save category: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func saveBooks(_ books: [BookRealm]) {
        DispatchQueue.global(qos: .background).async {
            autoreleasepool {
                do {
                    let realm = try Realm()
                    try realm.write {
                        for book in books {
                            realm.add(book, update: .modified)
                        }
                    }
                } catch {
                    print("Failed to save books: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func saveBookImages(_ images: [BookRealm]) {
        DispatchQueue.global(qos: .background).async {
            autoreleasepool {
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(images, update: .modified)
                    }
                } catch {
                    print("Failed to save book images: \(error.localizedDescription))")
                }
            }
        }
    }
    
    // MARK: - Fetch operations

    func getAllCategories() -> Results<CategoryRealm>? {
        do {
            let realm = try Realm()
            return realm.objects(CategoryRealm.self)
        } catch {
            print("Failed to initialize Realm: \(error.localizedDescription)")
            return nil
        }
    }

    func getAllBooks(for category: String) -> Results<BookRealm>? {
        do {
            let realm = try Realm()
            let realmBooks = realm.objects(BookRealm.self).filter("category == %@", category)
            return realmBooks.isEmpty ? nil : realmBooks
        } catch {
            print("Failed to initialize Realm: \(error.localizedDescription)")
            return nil
        }
    }

    func getAllBookImages() -> Results<BookRealm>? {
        do {
            let realm = try Realm()
            return realm.objects(BookRealm.self).filter("bookImage != nil")
        } catch {
            print("Failed to initialize Realm: \(error.localizedDescription)")
            return nil
        }
    }

    func getBook(with id: String) -> BookRealm? {
        do {
            let realm = try Realm()
            return realm.object(ofType: BookRealm.self, forPrimaryKey: id)
        } catch {
            print("Failed to initialize Realm: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - Update operations
    
    func updateCategory(id: String, with newCategory: CategoryRealm) {
        DispatchQueue.global(qos: .background).async {
            autoreleasepool {
                do {
                    let realm = try Realm()
                    guard let categoryToUpdate = realm.object(ofType: CategoryRealm.self, forPrimaryKey: id) else { return }
                    
                    try realm.write {
                        categoryToUpdate.name = newCategory.name
                        categoryToUpdate.newestPublishedDate = newCategory.newestPublishedDate
                        categoryToUpdate.listNameEncoded = newCategory.listNameEncoded
                    }
                } catch {
                    print("Failed to update category: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func updateBook(id: String, with newBook: BookRealm) {
        DispatchQueue.global(qos: .background).async {
            autoreleasepool {
                do {
                    let realm = try Realm()
                    guard let bookToUpdate = realm.object(ofType: BookRealm.self, forPrimaryKey: id) else { return }
                    
                    try realm.write {
                        bookToUpdate.id = newBook.id
                        bookToUpdate.rank = newBook.rank
                        bookToUpdate.title = newBook.title
                        bookToUpdate.bookDescription = newBook.bookDescription
                        bookToUpdate.author = newBook.author
                        bookToUpdate.publisher = newBook.publisher
                        bookToUpdate.bookImage = newBook.bookImage
                        bookToUpdate.buyLinks.removeAll()
                        bookToUpdate.buyLinks.append(objectsIn: newBook.buyLinks)
                    }
                } catch {
                    print("Failed to update book: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func updateBookImageData(bookId: String, imageData: String?) {
        DispatchQueue.global(qos: .background).async {
            autoreleasepool {
                do {
                    let realm = try Realm()
                    guard let bookToUpdate = realm.object(ofType: BookRealm.self, forPrimaryKey: bookId) else { return }
                    
                    try realm.write {
                        bookToUpdate.bookImage = imageData
                    }
                } catch {
                    print("Failed to update book image data)")
                }
            }
        }
    }
}
