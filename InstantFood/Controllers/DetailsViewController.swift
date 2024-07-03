//
//  DetailsViewController.swift
//  InstantFood
//
//  Created by Macbook Pro on 30/04/2024.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet var recipeImage : UIImageView!
    @IBOutlet var scrollView : UIView!
    @IBOutlet var detailsTable: UITableView!
    @IBOutlet var missedIngredientsLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var detailsSegment : UISegmentedControl!
    
    var titleOfRecipe : String?
    var imageURL : String? {
        didSet {
            if let urlString = imageURL , let url = URL(string: urlString) {
                DispatchQueue.global().async {
                    let imageData = try? Data(contentsOf: url)
                    DispatchQueue.main.async {
                        if let safeData = imageData {
                            self.recipeImage.image = UIImage(data: safeData)
                        }
                    }
                }
            }
        }
    }
    var missingIng : [String] = []
    var usedIng : [String] = []
    var ingredientsArray : [String] = []
    var instructionsArray : [String] = ["no instructions avalible"]
    var missingIngredientsCount : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        ingredientsArray.append(contentsOf: missingIng)
        ingredientsArray.append(contentsOf: usedIng)
        
        titleLabel.text = titleOfRecipe
        missedIngredientsLabel.text = "\(K.missingIng) \(String(describing: missingIngredientsCount ?? 0))"
        
        detailsTable.dataSource = self
        detailsTable.delegate = self

        Border.addBorder(scrollView)
        Border.addBorder(detailsSegment)
        Border.addBorder(detailsTable)
        setupSegmentControl()
        
    }
    
    @objc func segmentChange(_ sender : UISegmentedControl){
        detailsTable.reloadData()
        detailsSegment.setTitleTextAttributes([.foregroundColor : K.lightColor!], for: .selected)
    }

    
    func setupSegmentControl(){
        detailsSegment.selectedSegmentIndex = 0
        detailsSegment.setTitleTextAttributes([.foregroundColor : K.lightColor!], for: .selected)
        detailsSegment.addTarget(self, action: #selector(segmentChange(_:)), for: .valueChanged)
    }
}



// MARK: - table view datasource
extension DetailsViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if detailsSegment.selectedSegmentIndex == 0 {
            return ingredientsArray.count
        } else {
            return instructionsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.detailsVCCIdentifier, for: indexPath)
        
        if detailsSegment.selectedSegmentIndex == 0 {
                cell.textLabel?.text = ingredientsArray[indexPath.row]
            } else {
                cell.textLabel?.text = instructionsArray[indexPath.row]
            }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        detailsTable.deselectRow(at: indexPath, animated: true)
    }
}
