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
        let urlString = "\(recipeURL)\(APIKey.apikey)&includeIngredients=\(ingredients)&fillIngredients=true"
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
             //       let data = String(data: safeData, encoding: .utf8)
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
                var missedIngredients: [MissedIngredients] = []
                
                for ingredient in result.missedIngredients {
                        missedIngredients.append(ingredient)
                      }
                
                var usedIngredients: [UsedIngredients] = []
                
                for ingredient in result.usedIngredients {
                          usedIngredients.append(ingredient)
                    }
                
                let newRecipe = RecipeModel(title: title,
                                            image: image,
                                            missedIngredientsCount: count,
                                            missedIngredients: missedIngredients,
                                            usedIngredients: usedIngredients)
                recipe.append(newRecipe)
                
            }
            return recipe
        }
        catch {
            delegate?.didCatchError(error)
            print("error parsing data",error.localizedDescription)
            return nil
        }
    }
}
