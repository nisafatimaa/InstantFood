//
//  ViewController.swift
//  InstantFood
//
//  Created by Macbook Pro on 05/04/2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var ingredientsField : UITextField!
    @IBOutlet var suggestionsTable: UITableView!
    @IBOutlet var labels: [UILabel]!
    
    var shape : CAShapeLayer?
    var suggestionsManager = SuggestionsManager()
    var suggestionsArray : [String] = []
    var hiddenLabelNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        suggestionsTable.delegate = self
        suggestionsTable.dataSource = self
        suggestionsManager.delegate = self
        ingredientsField.delegate = self
        drawBottomLayer()
        Border.addBorder(ingredientsField)
    }
    
    
    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
        for label in labels {
            if label.text != K.empty {
                label.text = K.empty
                label.layer.borderColor = UIColor.clear.cgColor
            }
        }
        hiddenLabelNum = 0
    }
    
    @IBAction func getRecipePressed(_ sender: UIButton) {
        
        var ingredientsArray = [String]()
        var hasIngredient = false
        
        for label in labels {
            if label.text != K.empty {
                ingredientsArray.append(label.text!)
                hasIngredient = true
            }
        }
        
        if !hasIngredient {
            AlertMessage.showAlertMessage(K.noIngredientsTitle, K.noIngredientsMessage, self)
        }
        
        let ingredients = ingredientsArray.joined(separator: ",")
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: K.recipeVCIdentifier) as? RecipeViewController else {
            return
        }
        vc.ingredients = ingredients
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let text = ingredientsField.text, !text.isEmpty else {
            return
        }
        
        if hiddenLabelNum >= labels.count {
            AlertMessage.showAlertMessage(K.enoughIngredientsTitle, K.enoughIngredeintsMessage, self)
        }
        
        let label = labels[hiddenLabelNum]
        label.text = text
        hiddenLabelNum += 1
        ingredientsField.text = K.empty
        suggestionsTable.isHidden = true
        Border.addBorder(label)
    }
    
    func drawBottomLayer(){
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = K.brownColor?.cgColor
        shapeLayer.path = BezierPath.createPath(in: view.frame).cgPath
        self.view.layer.addSublayer(shapeLayer)
        self.shape = shapeLayer
    }
}



// MARK: - TableView

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        cell.textLabel?.text = suggestionsArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        ingredientsField.text = suggestionsArray[indexPath.row]
        suggestionsTable.isHidden = true
    }
}


// MARK: - TextField

extension ViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        suggestionsManager.fetchIngredients(with: newText)
        if newText.isEmpty {
            suggestionsTable.isHidden = true
            suggestionsArray = []
        } else {
            suggestionsTable.isHidden = false
        }
        suggestionsTable.reloadData()
        return true
    }
}


// MARK: - SuggestionsManagerDelegate

extension ViewController : SuggestionsManagerDelegate {
    
    func didUpdateSuggestions(_ suggestions: [String]) {
        suggestionsArray = []
        suggestionsArray.append(contentsOf: suggestions)
        DispatchQueue.main.async {
            self.suggestionsTable.reloadData()
        }
    }
    
    func didCatchError(_ error: Error) {
        AlertMessage.showAlertMessage("error",error.localizedDescription, self)
    }
}
