

import Foundation

struct User: Codable {
    let id: Int
    let username: String
    let email: String
    let address: Address
}

struct Address: Codable {
    let street: String
    let city: String
}
