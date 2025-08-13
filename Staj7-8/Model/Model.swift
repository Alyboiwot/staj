//
//  Model.swift
//  Staj7-8
//
//  Created by Ali Ünal UZUNÇAYIR on 13.08.2025.
//

import Foundation


struct Post : Codable {
    let userId : Int
    let id : Int
    let title : String
    let body : String
}
