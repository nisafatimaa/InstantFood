//
//  RecipeManager.swift
//  InstantFood
//
//  Created by Macbook Pro on 23/04/2024.
//

import Foundation

protocol RecipeManagerDelegate {
    func didUpdateRecipe (_ recipe : [RecipeModel])
    func didCatchError (_ error : Error)
}

struct RecipeManager {
    let recipeURL = "https://api.spoonacular.com/recipes/complexSearch?"
    
    var delegate : RecipeManagerDelegate?
    
    func fetchRecipe(of ingredients : String){
        let urlString = "\(recipeURL)\(APIKey.apikey)&\(ingredients)&fillIngredients=true&instructionsRequired=true"
        performTask(with: urlString)
        
    }
    
    func performTask(with urlString : String){
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.didCatchError(error!)
                    return
                }
                if let safeData = data {
                    if let recipe = parseJSON(safeData) {
                        delegate?.didUpdateRecipe(recipe)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data : Data) -> [RecipeModel]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(RecipeData.self, from: data)
            var recipe : [RecipeModel] = []
            for result in decodedData.results {
                let image = result.image
                let title = result.title
                let count = result.missedIngredientCount
                let newRecipe = RecipeModel(title: title, image: image, missedIngredientsCount: count)
                recipe.append(newRecipe)
            }
            return recipe
        }
        catch {
            delegate?.didCatchError(error)
            return nil
        }
    }
}
