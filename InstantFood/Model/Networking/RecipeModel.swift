//
//  RecipeModel.swift
//  InstantFood
//
//  Created by Macbook Pro on 23/04/2024.
//

import Foundation

struct RecipeSearchResponse: Codable {
    let hits: [RecipeHit]
}

struct RecipeHit: Codable {
    let recipe: Recipe
}

struct Recipe: Codable {
    let label: String
    let image: String
    let ingredientLines: [String]
    let url: String
    let totalTime : Int
}
