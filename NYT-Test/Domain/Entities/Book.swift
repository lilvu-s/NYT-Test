//
//  BooksModel.swift
//  NYT-Test
//
//  Created by Ангеліна Семенченко on 03.07.2023.
//

import Foundation
import UIKit

struct BooksResponse: Codable {
    let results: ResultContainer
}

struct ResultContainer: Codable {
    let listName: String
    let listNameEncoded: String
    let books: [Book]
    
    enum CodingKeys: String, CodingKey {
        case listName = "list_name"
        case listNameEncoded = "list_name_encoded"
        case books
    }
}

struct Book: Codable {
    var id: String {
        return "\(title)\(author)".data(using: .utf8)?.sha1() ?? ""
    }
    
    let rank: Int
    let title: String
    let description: String?
    let author: String
    let publisher: String
    var bookImage: URL?
    let buyLinks: [BuyLink]
    
    struct BuyLink: Codable {
        let name: String
        let url: URL
    }
    
    enum CodingKeys: String, CodingKey {
        case rank
        case title
        case description
        case author
        case publisher
        case bookImage = "book_image"
        case buyLinks = "buy_links"
    }
}
