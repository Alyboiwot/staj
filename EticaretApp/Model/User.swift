//
//  User.swift
//  EticaretApp
//
//  Created by Ali Ünal UZUNÇAYIR on 19.08.2025.
//

import Foundation

struct User {
    let id: String
    let email: String
    let role: String
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.email = data["email"] as? String ?? ""
        self.role = data["role"] as? String ?? "user"
    }
}
