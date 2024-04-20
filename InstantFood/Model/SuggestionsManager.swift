//
//  SuggestionsManager.swift
//  InstantFood
//
//  Created by Macbook Pro on 20/04/2024.
//

import Foundation

protocol SuggestionsManagerDelegate {
    func didUpdateSuggestions(_ suggestions : [String])
    func didCatchError(_error : Error)
}

struct SuggestionsManager {
    
    let suggestionsURL = "https://api.spoonacular.com/recipes/autocomplete?apiKey=73ab19e64007404eaba3c9f48c4340e7"
    
    var delegate : SuggestionsManagerDelegate?
    
    //fetching ingredients based on textfield text
    func fetchIngredients(with text : String){
        let urlString = "\(suggestionsURL)&query=\(text)&number=5"
        performTask(urlString: urlString)
    }
    
    func performTask(urlString : String){
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                   delegate?.didCatchError(_error: error!)
                    return
                }
                if let safeData = data {
                    let suggestions = parseJSON(data: safeData)
                    delegate?.didUpdateSuggestions(suggestions)
                }
            }
            task.resume()
        }
        
    }
    
    func parseJSON(data : Data) -> [String] {
        let decoder = JSONDecoder()
        do {
            let decodedData : [SuggestionsData] = try decoder.decode([SuggestionsData].self, from: data)
            let suggestions = decodedData.map{$0.title}
            return suggestions
        }
        catch {
            delegate?.didCatchError(_error: error)
            return []
        }
    }
}
