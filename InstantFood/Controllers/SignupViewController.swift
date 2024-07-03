//
//  SignupViewController.swift
//  InstantFood
//
//  Created by Macbook Pro on 02/07/2024.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet var nameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet weak var registerSegment : UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerSegment.selectedSegmentIndex = 0
        registerSegment.setTitleTextAttributes([.foregroundColor : K.lightColor!], for: .selected)
        
        navigationItem.hidesBackButton = true
        
    }
    
    @IBAction func registerSegment(_ sender: UISegmentedControl) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: K.loginVCIdentifier) as? LoginViewController else { return }
         navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func signupClicked(_ sender: UIButton) {
    }
    
    @IBAction func googleSignup(_ sender: UIButton) {
    }
    
    @IBAction func facebookSignup(_ sender: UIButton) {
    }
    
    @IBAction func backpressed(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: K.welcomeVCTIdentifier) as? WelcomeViewControllerTwo else { return }
         navigationController?.pushViewController(vc, animated: true)
    }
}
