//
//  RecipeViewController.swift
//  InstantFood
//
//  Created by Macbook Pro on 29/04/2024.
//

import UIKit

class RecipeViewController: UIViewController {

// MARK: - IBOutlet
    @IBOutlet weak var recipeTableView : UITableView!
    
    
// MARK: - Variables
    var recipeArray : [Recipe] = []
    var savedRecipes : [Recipe] = []
    var recipeManager = RecipeManager()
    var ingredients : String = " "
    
    
// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeTableView.rowHeight = 100
        recipeManager.fetchRecipes(withIngredients: ingredients) { [weak self] recipes in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let recipes = recipes {
                    self.recipeArray = recipes
                    self.recipeTableView.reloadData()
                }
                else {
                    AlertMessage.showAlertMessage("Network issue", "Please try again", self)
                }
            }
        }
        
        navigationController?.navigationBar.tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor.white]
        self.navigationItem.title = "Recipes"
        
        recipeTableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.TVCCellIdentifier)
    }
}


// MARK: - TableViewDelegate
extension RecipeViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRecipe = recipeArray[indexPath.row]
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: K.detailsVCIdentifier) as? DetailsViewController else { return }
        
        vc.imageURL = selectedRecipe.image
        vc.titleOfRecipe = selectedRecipe.label
        vc.ingredientsArray = selectedRecipe.ingredientLines
        vc.cookingTime = selectedRecipe.totalTime
        vc.instructionsURL = selectedRecipe.url
        
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: - TableViewDataSource
extension RecipeViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TVCCellIdentifier, for: indexPath) as! RecipeTableViewCell
        
        let recipe = recipeArray[indexPath.row]
        cell.imageURL = recipe.image
        cell.titleLabel.text = recipe.label
        cell.cookingTime.text = "Cooking Time: \(recipe.totalTime) min"
        cell.saveRecipeAction = { [weak self] in
            self?.saveRecipe(recipe)
        } //the function is assigned to closure which is called when heart button is tapped
        
        return cell
    }
    
    func saveRecipe(_ recipe : Recipe) {
        if let index = savedRecipes.firstIndex(where: { $0.label == recipe.label }) {
            savedRecipes.remove(at: index)
            print("Recipe removed: \(recipe.label)")
        } else {
            savedRecipes.append(recipe)
            print("Recipe saved: \(recipe.label)")
        }
    }
}
