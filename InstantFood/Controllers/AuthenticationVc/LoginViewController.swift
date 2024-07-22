//
//  LoginViewController.swift
//  InstantFood
//
//  Created by Macbook Pro on 02/07/2024.
//

import UIKit

class LoginViewController: UIViewController {

    
// MARK: - IBOutlets
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet weak var registerSegment : UISegmentedControl!
    @IBOutlet weak var loginButton : UIButton!
    
    
// MARK: - Variables
    private var isEmailValid = false
    private var isPasswordValid = false
    
    var loginManager = LoginManager()
    var signupManager = SignupManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerSegment.selectedSegmentIndex = 1
        registerSegment.setTitleTextAttributes([.foregroundColor : UIColor.white], for: .selected)
        
        navigationItem.hidesBackButton = true
        updateLoginButton()
    }
    
    
// MARK: - Buttons
    @IBAction func registerSegment(_ sender: UISegmentedControl) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: K.signupVCIdentifier) as? SignupViewController else { return }
         navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func loginClicked(_ sender: UIButton) {
        guard let email = emailField.text,
              let password = passwordField.text else { return }
        loginManager.loginWithEmail(self, email, password)
    }
    
    
    @IBAction func googleLogin(_ sender: UIButton) {
        loginManager.signupWithGoogle(self)
    }
    
    
    @IBAction func backpressed(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: K.signupVCIdentifier) as? SignupViewController else { return }
         navigationController?.pushViewController(vc, animated: true)
    }
    
    
// MARK: - Functions
    func updateLoginButton () {
        loginButton.isEnabled = isEmailValid && isPasswordValid
        loginButton.backgroundColor = loginButton.isEnabled ? K.primaryColor : K.primaryColor?.withAlphaComponent(0.7)
    }
}



// MARK: - TextFieldDelegate
extension LoginViewController : UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if textField == emailField {
            isEmailValid = signupManager.isEmailValid(textField.text ?? "")
            
        } else if textField == passwordField {
            isPasswordValid = signupManager.isPasswordValid(textField.text ?? "")
        
        }
        updateLoginButton()
    }
}
