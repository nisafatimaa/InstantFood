//
//  LoginViewController.swift
//  InstantFood
//
//  Created by Macbook Pro on 02/07/2024.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet weak var registerSegment : UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerSegment.selectedSegmentIndex = 1
        registerSegment.setTitleTextAttributes([.foregroundColor : K.lightColor!], for: .selected)
        
        navigationItem.hidesBackButton = true
    }
    
    @IBAction func registerSegment(_ sender: UISegmentedControl) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: K.signupVCIdentifier) as? SignupViewController else { return }
         navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func loginClicked(_ sender: UIButton) {
    }
    
    @IBAction func googleLogin(_ sender: UIButton) {
    }
    
    @IBAction func facebookLogin(_ sender: UIButton) {
    }
    
    @IBAction func backpressed(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: K.signupVCIdentifier) as? SignupViewController else { return }
         navigationController?.pushViewController(vc, animated: true)
    }
}
