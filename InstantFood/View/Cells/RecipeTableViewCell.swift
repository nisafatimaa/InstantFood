//
//  RecipeTableViewCell.swift
//  InstantFood
//
//  Created by Macbook Pro on 29/04/2024.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var cookingTime: UILabel!
    @IBOutlet var DishImage: UIImageView!
    @IBOutlet var heartButton : UIButton!
    
    var imageURL : String? {
        didSet {
            if let urlString = imageURL , let url = URL(string: urlString) {
                DispatchQueue.global().async {
                    let imageData = try? Data(contentsOf: url)
                    DispatchQueue.main.async {
                        if let safeData = imageData {
                            self.DishImage.image = UIImage(data: safeData)
                        }
                    }
                }
            }
        }
    }
    
    //closure
    var saveRecipeAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = K.primaryColor?.cgColor
        contentView.layer.cornerRadius = 7
        Border.addBorder(DishImage)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func heartClicked(_ sender: UIButton) {
        heartButton.setImage(UIImage(systemName: heartButton.currentImage == UIImage(systemName: "heart") ? "heart.fill" : "heart"), for: .normal)
        saveRecipeAction?()
    }
}
