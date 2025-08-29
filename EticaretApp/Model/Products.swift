//
//  Products.swift
//  EticaretApp
//
//  Created by Ali Ünal UZUNÇAYIR on 19.08.2025.
//

import Foundation

struct Product {
    let id: String
    let name: String
    let price: Double
    let description: String
    let imageUrl: String
    let category: String
    let inStock: Bool
    let brand: String?
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.name = data["name"] as? String ?? ""
        self.price = data["price"] as? Double ?? 0.0
        self.description = data["description"] as? String ?? ""
        self.imageUrl = data["imageUrl"] as? String ?? ""
        self.category = data["category"] as? String ?? "Genel"
        self.inStock = data["inStock"] as? Bool ?? true
        self.brand = data["brand"] as? String
    }
}
