//
//  WelcomeViewController.swift
//  InstantFood
//
//  Created by Tayyab on 22/07/2024.
//

import UIKit
import KeychainSwift

class WelcomeViewController: UIViewController {
    
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    
    
    // MARK: - Variables
    var charIndex = 0.0
    let titleText = "InstantFood👨🏻‍🍳"
    let keychain = KeychainSwift()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleAnimation()
    }
    
    
    // MARK: - Buttons
    @IBAction func ContinueButton(_ sender: UIButton) {
        
        if keychain.get("authToken") != nil {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: K.ingredientsVCIdentifier) as? IngredientsViewController else { return }
            navigationController?.pushViewController(vc, animated: true)
            
        } else {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: K.welcomeVCOIdentifier) as? WelcomeViewControllerOne else { return }
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
    // MARK: - Functions
    func titleAnimation(){
        
        titleLabel.text = ""
        
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }
    }
}
