//
//  SuggestionsManager.swift
//  InstantFood
//
//  Created by Macbook Pro on 20/04/2024.
//

import Foundation

protocol SuggestionsManagerDelegate {
    func didUpdateSuggestions(_ suggestions : [String])
    func didCatchError(_ error : Error)
}

struct SuggestionsManager {
    let suggestionsURL = "https://api.spoonacular.com/recipes/autocomplete?"
    
    var delegate : SuggestionsManagerDelegate?
    
    //fetching ingredients based on textfield text
    func fetchIngredients(with text : String){
        let urlString = "\(suggestionsURL)\(APIKey.apikey)&query=\(text)&number=5"
        performTask(urlString: urlString)
    }
    
    func performTask(urlString : String){
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                   delegate?.didCatchError(error!)
                    return
                }
                if let safeData = data {
                    let suggestions = parseJSON(safeData)
                    delegate?.didUpdateSuggestions(suggestions)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data : Data) -> [String] {
        let decoder = JSONDecoder()
        do {
            let decodedData : [SuggestionsData] = try decoder.decode([SuggestionsData].self, from: data)
            let suggestions = decodedData.map{$0.title}
            return suggestions
        }
        catch {
            delegate?.didCatchError(error)
            return []
        }
    }
}
