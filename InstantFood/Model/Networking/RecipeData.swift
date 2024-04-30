//
//  RecipeData.swift
//  InstantFood
//
//  Created by Macbook Pro on 23/04/2024.
//

import Foundation

struct RecipeData : Codable {
    let results : [Result]
}

struct Result : Codable{
    let title : String
    let image : String
    let missedIngredientCount : Int
//    let usedIngredients : [UsedIngredients]
//    let missedIngrdients : [MissedIngredients]
}

//struct MissedIngredients : Codable {
//    let original : String
//}
//
//struct UsedIngredients : Codable {
//    let original : String
//}
