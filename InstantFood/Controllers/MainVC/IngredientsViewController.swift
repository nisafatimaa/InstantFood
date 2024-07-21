//
//  IngredientsViewController.swift
//  InstantFood
//
//  Created by Macbook Pro on 11/07/2024.
//

import UIKit

class IngredientsViewController: UIViewController {

    @IBOutlet var ingredientSearchBar: UISearchBar!
    @IBOutlet var ingredientTable: UITableView!
    @IBOutlet var ingredientsStackViews: [UIStackView]!
    
    var shape : CAShapeLayer?
    var recipeManager = RecipeManager()
    
    private var ingredients : [Ingredient] = []
    private var filteredIngredients : [Ingredient] = []
    private var selectedIngredients : [Ingredient] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredients = loadIngredients()
        filteredIngredients = ingredients
        
        navigationItem.hidesBackButton = true
        
        drawBottomLayer()
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
    
    
    func drawBottomLayer(){
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = K.primaryColor?.cgColor
        shapeLayer.path = BezierPath.createPath(in: view.frame).cgPath
        self.view.layer.addSublayer(shapeLayer)
        self.shape = shapeLayer
    }
    
    @IBAction func searchIngredient(_ sender: UIButton) {
        let searchString = ingredientSearchBar.text ?? ""
        filterIngredient(searchString)
        ingredientTable.reloadData()
    }
    
    @IBAction func getRecipesButton(_ sender: UIButton) {
        
        let ingredients = selectedIngredients.map {$0.title}.joined(separator: ",")
        guard let vc = storyboard?.instantiateViewController(withIdentifier: K.recipeVCIdentifier) as? RecipeViewController else { return }
        vc.ingredients = ingredients
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
extension IngredientsViewController : LabelWithDelButtonDelegate {
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
extension IngredientsViewController : UITableViewDelegate {
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
extension IngredientsViewController : UITableViewDataSource {
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
extension IngredientsViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = ingredientSearchBar.text ?? ""
        
        if searchText.isEmpty {
            filteredIngredients = ingredients
        } else {
            let searchString = searchText.lowercased()
            filterIngredient(searchString)
        }
        ingredientTable.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        ingredientTable.isHidden = false
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
