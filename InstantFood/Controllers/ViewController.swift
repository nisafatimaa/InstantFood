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
    
    var shape : CAShapeLayer?
    var suggestions = Suggestions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredientsField.layer.cornerRadius = 18
        ingredientsField.layer.borderWidth = 2
        ingredientsField.layer.borderColor = K.brownColor?.cgColor
        
        suggestionsTable.delegate = self
        suggestionsTable.dataSource = self
        ingredientsField.delegate = self
        
        //when we click outside field or table view
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissTableView))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func dismissTableView() {
        view.endEditing(true)
        suggestionsTable.isHidden = true
    }
    
    //it will be called whenever layout changer
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        shape?.removeFromSuperlayer()
        drawBottomLayer()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
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
        return suggestions.filteredElements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        cell.textLabel?.text = suggestions.filteredElements[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filteredText = suggestions.filteredElements[indexPath.row]
        ingredientsField.text = filteredText
        suggestionsTable.isHidden = true
    }
    
}



// MARK: - TextField

extension ViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if newText.isEmpty {
            suggestionsTable.isHidden = false
        }
        else if newText.count >= 0 {
            suggestions.filteredElements = suggestions.elements.filter { $0.lowercased().hasPrefix(newText.lowercased()) }
        } else {
            suggestions.filteredElements = []
        }
        
        suggestionsTable.reloadData()
        return true
    }
    
    //when clicked textfield
    func textFieldDidBeginEditing(_ textField: UITextField) {
        suggestionsTable.isHidden = false
    }
    
    //when we hit return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        ingredientsField.endEditing(true)
        return true
    }
}

