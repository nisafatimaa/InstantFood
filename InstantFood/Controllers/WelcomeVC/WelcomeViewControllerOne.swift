//
//  WelcomeViewControllerOne.swift
//  InstantFood
//
//  Created by Macbook Pro on 02/07/2024.
//

import UIKit

class WelcomeViewControllerOne: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
    }
    
    @IBAction func NextButton(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: K.welcomeVCTIdentifier) as? WelcomeViewControllerTwo else { return }
         navigationController?.pushViewController(vc, animated: true)
    }
}
