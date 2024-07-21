//
//  RecipeManager.swift
//  InstantFood
//
//  Created by Macbook Pro on 23/04/2024.
//

import Foundation
import Alamofire

struct RecipeManager {
    
    private let baseURL = "https://api.edamam.com/api/recipes/v2"
    
    func fetchRecipes(withIngredients ingredients: String, completion : @escaping ([Recipe]?) -> Void) {
            let parameters: [String: Any] = [
                "type": "public",
                "q": ingredients,
                "app_id": APIKey.apiId,
                "app_key": APIKey.apiKey,
                "time": "1-120",
                "imageSize": "REGULAR"
            ]

            AF.request(baseURL, parameters: parameters).responseDecodable(of: RecipeSearchResponse.self) { response in
                switch response.result {
                case .success(let data):
                    completion(data.hits.map { $0.recipe })
                    
                case .failure(let error):
                    print("Error fetching recipes: \(error)")
                    completion(nil)
                }
            }
        }
    }
