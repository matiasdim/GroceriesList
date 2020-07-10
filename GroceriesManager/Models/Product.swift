//
//  Product.swift
//  GroceriesManager
//
//  Created by Matías Gil Echavarría on 7/7/20.
//  Copyright © 2020 Matías Gil Echavarría. All rights reserved.
//

import UIKit

enum Category: String, CaseIterable, Codable {
    case other = "Other"
    case vegetables = "Vegetables"
    case dairy = "Dairy"
    case snacks = "Snacks"
}

class Product: NSObject, Codable {
    var id: String
    var name: String
    var notes: String
    var category: Category
    
    init(name: String, notes: String, category: Category) {
        self.id = UUID().uuidString
        self.name = name
        self.notes = notes
        self.category = category
    }
}
