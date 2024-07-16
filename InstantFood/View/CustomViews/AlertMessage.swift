//
//  AlertMessage.swift
//  InstantFood
//
//  Created by Macbook Pro on 30/04/2024.
//

import UIKit

struct AlertMessage {
    
    static func showAlertMessage (_ title : String, _ message : String,_ vc : UIViewController) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        vc.present(alert, animated: true)
        return
    }
}
