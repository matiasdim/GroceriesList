//
//  Product.swift
//  GroceriesManager
//
//  Created by Matías Gil Echavarría on 7/7/20.
//  Copyright © 2020 Matías Gil Echavarría. All rights reserved.
//

import UIKit

enum Category: String, CaseIterable {
    case none = "None"
    case vegetables = "Vegetables"
    case dairy = "Dairy products"
    case snacks = "Snacks"
    case other = "Other"
}

class Product: NSObject {
    var id: String
    var name: String
    var observation: String
    var category: Category
    
    init(name: String, observation: String, category: Category) {
        self.id = UUID().uuidString
        self.name = name
        self.observation = observation
        self.category = category
    }
}
