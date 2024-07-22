//
//  WelcomeViewControllerTwo.swift
//  InstantFood
//
//  Created by Macbook Pro on 02/07/2024.
//

import UIKit

class WelcomeViewControllerTwo: UIViewController {

    
// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
    }
    
    
// MARK: - Buttons
    @IBAction func RegisterButton(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: K.signupVCIdentifier) as? SignupViewController else { return }
         navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backpressed(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: K.welcomeVCOIdentifier) as? WelcomeViewControllerOne else { return }
         navigationController?.pushViewController(vc, animated: true)
    }
}
