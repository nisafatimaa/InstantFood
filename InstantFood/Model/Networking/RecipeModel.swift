//
//  RecipeModel.swift
//  InstantFood
//
//  Created by Macbook Pro on 23/04/2024.
//

import Foundation

struct RecipeModel {
    var title : String
    var image : String
    var missedIngredientsCount : Int
    var missedIngredients : [MissedIngredients]
    var usedIngredients : [UsedIngredients]
}