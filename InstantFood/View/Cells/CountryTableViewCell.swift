//
//  CountryTableViewCell.swift
//  InstantFood
//
//  Created by Macbook Pro on 09/07/2024.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

    @IBOutlet var CountryName: UILabel!
    @IBOutlet var flagImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
