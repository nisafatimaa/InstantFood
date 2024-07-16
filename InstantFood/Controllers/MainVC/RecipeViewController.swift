//
//  RecipeViewController.swift
//  InstantFood
//
//  Created by Macbook Pro on 29/04/2024.
//

import UIKit

class RecipeViewController: UIViewController {

    @IBOutlet weak var recipeTableView : UITableView!
    
    var recipeArray : [RecipeModel] = []
    var recipeManager = RecipeManager()
    var ingredients : String = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeManager.delegate = self
        
        recipeTableView.rowHeight = 100
        recipeManager.fetchRecipe(of: ingredients)
        
        navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = "Recipes"
        
        recipeTableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.TVCCellIdentifier)
    }
}


// MARK: - TableViewDelegate
extension RecipeViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedRecipe = recipeArray[indexPath.row]
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: K.detailsVCIdentifier) as? DetailsViewController else {
            return
        }
        vc.imageURL = selectedRecipe.image
        vc.titleOfRecipe = selectedRecipe.title
        vc.missingIngredientsCount = selectedRecipe.missedIngredientsCount
        
        for i in selectedRecipe.missedIngredients {
            vc.missingIng.append(i.original)
        }
        for i in selectedRecipe.usedIngredients {
            vc.usedIng.append(i.original)
        }
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
        
        let indexRow = recipeArray[indexPath.row]
        cell.imageURL = indexRow.image
        cell.titleLabel.text = indexRow.title
        cell.missedIngredientCount.text = "missing ingredients : \(String(indexRow.missedIngredientsCount))"
        return cell
    }
}


// MARK: - RecipeManagerDelegate
extension RecipeViewController : RecipeManagerDelegate {

    func didUpdateRecipe(_ recipe: [RecipeModel]) {
        recipeArray = []
        recipeArray.append(contentsOf: recipe)
        DispatchQueue.main.async {
            self.recipeTableView.reloadData()
        }
    }

    func didCatchError(_ error: Error) {
        DispatchQueue.main.async {
            AlertMessage.showAlertMessage("Error", error.localizedDescription, self)
        }
    }
}
