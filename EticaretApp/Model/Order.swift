//
//  Order.swift
//  EticaretApp
//
//  Created by Ali Ünal UZUNÇAYIR on 19.08.2025.
//

import Foundation
import FirebaseCore

struct Order {
    let id: String
    let userId: String
    let productIds: [String]
    let totalAmount: Double
    let createdAt: Date
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.userId = data["userId"] as? String ?? ""
        self.productIds = data["productIds"] as? [String] ?? []
        self.totalAmount = data["totalAmount"] as? Double ?? 0.0
        if let timestamp = data["createdAt"] as? Timestamp {
            self.createdAt = timestamp.dateValue()
        } else {
            self.createdAt = Date()
        }
    }
}
