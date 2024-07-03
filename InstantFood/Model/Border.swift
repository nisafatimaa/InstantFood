//
//  Border.swift
//  InstantFood
//
//  Created by Macbook Pro on 22/05/2024.
//

import UIKit

struct Border {
    static func addBorder (_ view : UIView){
        view.layer.cornerRadius = 18
        view.layer.borderColor = K.brownColor?.cgColor
        view.layer.borderWidth = 2
    }
}
