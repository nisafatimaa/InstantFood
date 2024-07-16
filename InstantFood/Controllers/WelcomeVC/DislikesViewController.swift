//
//  DislikesViewController.swift
//  InstantFood
//
//  Created by Macbook Pro on 10/07/2024.
//

import UIKit

class DislikesViewController: UIViewController {
    
    @IBOutlet var ingredientsTableView: UITableView!
    @IBOutlet var ingredientsSearch: UISearchBar!
    @IBOutlet var ingredientsStackViews: [UIStackView]!
    
    private var ingredients : [Ingredient] = []
    private var filteredIngredients : [Ingredient] = []
    private var selectedIngredients : [Ingredient] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredients = loadIngredients()
        filteredIngredients = ingredients
        
        navigationItem.hidesBackButton = true
    }
    
    
    
    // MARK: - LoadingIngredients
    func loadIngredients() -> [Ingredient] {
        guard let path = Bundle.main.path(forResource: "ingredients", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            print("Unable to load JSON file")
            return []
        }
        
        let decoder = JSONDecoder()
        do {
            let ingredients = try decoder.decode([Ingredient].self, from: data)
            return ingredients
        } catch {
            print("Error decoding JSON: \(error)")
            return []
        }
    }
    
    
    // MARK: - Buttons
    @IBAction func searchPressed(_ sender: Any) {
        let searchString = ingredientsSearch.text ?? ""
        filterIngredient(searchString)
        ingredientsTableView.reloadData()
    }
    
    @IBAction func savePressed(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: K.ingredientsVCIdentifier) as? IngredientsViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backpressed(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: K.preferencesVCIdentifier) as? PreferencesViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    // MARK: - Labels
    func showCountryLabel (_ ingredient : Ingredient) {
        for stackView in ingredientsStackViews {
            if let emptyView = stackView.arrangedSubviews.first(where: {$0.subviews.isEmpty}) {
                
                let label = LabelWithDelButton()
                label.delegate = self
                label.configure(with: ingredient.title)
                Border.addBorder(label)
                emptyView.addSubview(label)
                
                label.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    label.topAnchor.constraint(equalTo: emptyView.topAnchor),
                    label.bottomAnchor.constraint(equalTo: emptyView.bottomAnchor),
                    label.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor),
                    label.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor)
                ])
                return
            }
        }
    }
}



// MARK: - LabelWithDelButtonDelegate
extension DislikesViewController : LabelWithDelButtonDelegate {
    func didDeleteLabel(with text: String) {
        if let index = selectedIngredients.firstIndex(where: { $0.title == text }) {
            selectedIngredients.remove(at: index)
        }
        removeAllLabels()
        showSelectedCountries()
    }
    
    func removeAllLabels() {
        for stackView in ingredientsStackViews {
            for view in stackView.arrangedSubviews {
                view.subviews.forEach { $0.removeFromSuperview() }
            }
        }
    }
    
    func showSelectedCountries() {
        for country in selectedIngredients {
            showCountryLabel(country)
        }
    }
}



// MARK: - TableViewDelegate
extension DislikesViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIngredient = filteredIngredients[indexPath.row]
        
        if selectedIngredients.firstIndex(of: selectedIngredient) == nil {
                selectedIngredients.append(selectedIngredient)
                showCountryLabel(selectedIngredient)
        } else { return }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}



// MARK: - TableViewDataSource
extension DislikesViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredIngredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.IngredientsTVCIdentifier, for: indexPath)
        
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = filteredIngredients[indexPath.row].title
            cell.contentConfiguration = content
            
        } else {
            cell.textLabel?.text = filteredIngredients[indexPath.row].title
        }
        return cell
    }
}
    
    
    // MARK: - SearchBarDelegate
    extension DislikesViewController : UISearchBarDelegate {
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            let searchText = ingredientsSearch.text ?? ""
            
            if searchText.isEmpty {
                filteredIngredients = ingredients
            } else {
                let searchString = searchText.lowercased()
                filterIngredient(searchString)
            }
            ingredientsTableView.reloadData()
        }
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            ingredientsTableView.isHidden = false
        }
        
        //filtering countries to show in tableview
        func filterIngredient (_ text : String) {
            filteredIngredients = ingredients.filter { Ingredient in
                let name = Ingredient.title.lowercased()
                return name.hasPrefix(text) ||
                (name.rangeOfCharacter(from: .letters) != nil && name.contains(text))
            }
        }
    }
