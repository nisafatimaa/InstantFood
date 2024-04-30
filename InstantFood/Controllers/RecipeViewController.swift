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
        
        recipeTableView.delegate = self
        recipeTableView.dataSource = self
        recipeManager.delegate = self
        
        recipeManager.fetchRecipe(of: ingredients)
        
        recipeTableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.TVCCellIdentifier)
    }
}


// MARK: - TableViewDelegate
extension RecipeViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: K.detailsVCIdentifier) as? DetailsViewController else {
            return
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TVCCellIdentifier, for: indexPath) as! RecipeTableViewCell
        
        let indexRow = recipeArray[indexPath.row]
        let m = "Missing ingredients: "
        cell.imageURL = indexRow.image
        cell.titleLabel.text = indexRow.title
        cell.missedIngredientCount.text = "\(m)\(String(indexRow.missedIngredientsCount))"
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
        AlertMessage.showAlertMessage("Error", error.localizedDescription, self)
    }
}
