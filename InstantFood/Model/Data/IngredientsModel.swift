//
//  IngredientsModel.swift
//  InstantFood
//
//  Created by Macbook Pro on 10/07/2024.
//

import Foundation

struct Ingredient : Codable, Equatable {
    var title : String
    
    static func ==(lhs: Ingredient, rhs: Ingredient) -> Bool {
        return lhs.title == rhs.title
    }
}
