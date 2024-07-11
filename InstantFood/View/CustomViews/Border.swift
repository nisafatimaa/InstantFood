//
//  Border.swift
//  InstantFood
//
//  Created by Macbook Pro on 22/05/2024.
//

import UIKit

struct Border {
    static func addBorder (_ view : UIView){
        view.layer.cornerRadius = 14
        view.layer.borderColor = K.primaryColor?.cgColor
        view.layer.borderWidth = 2
    }
}
