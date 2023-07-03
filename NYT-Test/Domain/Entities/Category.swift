//
//  Models.swift
//  NYT-Test
//
//  Created by Ангеліна Семенченко on 03.07.2023.
//

import Foundation

struct CategoriesResponse: Codable {
    let results: [Category]
}

struct Category: Codable {
    let name: String
    let newestPublishedDate: String
    let listNameEncoded: String

    enum CodingKeys: String, CodingKey {
        case name = "display_name"
        case newestPublishedDate = "newest_published_date"
        case listNameEncoded = "list_name_encoded"
    }
}
