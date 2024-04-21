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
       setupField()
    }
   
    //it will be called whenever layout changer
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        shape?.removeFromSuperlayer()
        drawBottomLayer()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let text = ingredientsField.text, !text.isEmpty else {
            return
        }
        
        if hiddenLabelNum >= labels.count {
            // make alert for ingredients exceding
            return
        }
        
        let label = labels[hiddenLabelNum]
        label.text = text
        label.layer.cornerRadius = 18
        label.layer.borderColor = K.brownColor?.cgColor
        label.layer.borderWidth = 2
        label.isHidden = false
        hiddenLabelNum += 1
        ingredientsField.text = " "
        
    }
    
    func setupField(){
        ingredientsField.layer.cornerRadius = 18
        ingredientsField.layer.borderWidth = 2
        ingredientsField.layer.borderColor = K.brownColor?.cgColor
        ingredientsField.delegate = self
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
        
        tableView.deselectRow(at: indexPath, animated: true)
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
    }
    func didCatchError(_error: Error) {
        print("error")
    }
}
