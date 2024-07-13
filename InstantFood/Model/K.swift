//
//  K.swift
//  InstantFood
//
//  Created by Macbook Pro on 16/04/2024.
//

import UIKit

struct K {
    static var primaryColor = UIColor(named: "PrimaryColor")
    
    static var cellIdentifier = "cell"
    static var TVCCellIdentifier = "recipeCell"
    static var cellNibName = "RecipeTableViewCell"
    static var countryCellNibName = "CountryTableViewCell"
    static var CountryCellIdentifier = "CountryCell"
    static var IngredientsTVCIdentifier = "DislikesCell"
    static var detailsVCCIdentifier = "detailsCell"
    
    static var empty = ""
    static var noIngredientsTitle = "No Ingredient Found."
    static var noIngredientsMessage = "Add at least one ingredient to find recipes."
    static var enoughIngredientsTitle = "Enough Ingredients"
    static var enoughIngredeintsMessage = "16 Ingredients are enough to find recipes."
    static var missingIng = "missing Ingredients count ="
    
    static var welcomeVCTIdentifier = "two"
    static var welcomeVCOIdentifier = "one"
    static var signupVCIdentifier = "signup"
    static var loginVCIdentifier = "login"
    static var preferencesVCIdentifier = "preferences"
    static var dislikesVCIdentifier = "dislikes"
    static var ingredientsVCIdentifier = "ingredients"
    static var recipeVCIdentifier = "recipe"
    static var detailsVCIdentifier = "details"
}
