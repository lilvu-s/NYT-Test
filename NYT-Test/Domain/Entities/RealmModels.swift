//
//  BookRealm.swift
//  NYT-Test
//
//  Created by Ангеліна Семенченко on 08.07.2023.
//

import Foundation
import RealmSwift

final class BookRealm: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var category: String
    @Persisted var rank: Int
    @Persisted var title: String
    @Persisted var bookDescription: String?
    @Persisted var author: String
    @Persisted var publisher: String
    @Persisted var bookImage: String?
    @Persisted var buyLinks: List<BuyLinkRealm>
}

final class BuyLinkRealm: EmbeddedObject {
    @Persisted var name: String
    @Persisted var url: String
    @Persisted(originProperty: "buyLinks") var book: LinkingObjects<BookRealm>
}

final class CategoryRealm: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var newestPublishedDate: String
    @Persisted var listNameEncoded: String
}

