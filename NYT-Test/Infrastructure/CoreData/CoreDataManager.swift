//
//  CoreDataManager.swift
//  NYT-Test
//
//  Created by Ангеліна Семенченко on 04.07.2023.
//

import CoreData

//TODO: both lists must be cashed and saved to core data

class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NYTTest")
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {}
}

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    func saveBook(book: Book) {
        let managedContext = CoreDataStack.shared.context
        let entity = NSEntityDescription.entity(forEntityName: "BookEntity", in: managedContext)!
        
        let bookEntity = NSManagedObject(entity: entity, insertInto: managedContext)
        bookEntity.setValue(book.title, forKeyPath: "title")
        // Set the other fields of the book
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchBooks() -> [Book]? {
        let managedContext = CoreDataStack.shared.context
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BookEntity")
        
        do {
            let bookEntities = try managedContext.fetch(fetchRequest)
            return bookEntities.map { Book(entity: $0) } // TODO
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return nil
    }
    
    // TODO: saveCategory, fetchCategories
}

extension Book {
    init?(entity: NSManagedObject) {
        guard
            let title = entity.value(forKey: "title") as? String,
            let description = entity.value(forKey: "description") as? String?,
            let author = entity.value(forKey: "author") as? String,
            let publisher = entity.value(forKey: "publisher") as? String,
            let urlString = entity.value(forKey: "bookImage") as? String,
            let bookImage = URL(string: urlString),
            let rank = entity.value(forKey: "rank") as? Int,
            let buyLinksData = entity.value(forKey: "buyLinks") as? Data,
            let buyLinks = try? JSONDecoder().decode([BuyLink].self, from: buyLinksData),
        else { return nil } // TODO

        self.title = title
        self.description = description
        self.author = author
        self.publisher = publisher
        self.bookImage = bookImage
        self.buyLinks = buyLinks
        self.rank = rank
    }
}

