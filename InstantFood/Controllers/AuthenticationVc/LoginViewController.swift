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
    @IBOutlet weak var loginButton : UIButton!
    
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
    
    @IBAction func registerSegment(_ sender: UISegmentedControl) {
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: K.signupVCIdentifier) as? SignupViewController else { return }
         navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func loginClicked(_ sender: UIButton) {
        
        guard let email = emailField.text,
              let password = passwordField.text else { return }
        
        validateInfo()
        loginManager.loginWithEmail(self, email, password)
        
    }
    
    @IBAction func googleLogin(_ sender: UIButton) {
        loginManager.signupWithGoogle(self)
    }
    
    @IBAction func facebookLogin(_ sender: UIButton) {
        
    }
    
    @IBAction func backpressed(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: K.signupVCIdentifier) as? SignupViewController else { return }
         navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateLoginButton () {
        loginButton.isEnabled = isEmailValid && isPasswordValid
        loginButton.backgroundColor = loginButton.isEnabled ? K.primaryColor : K.primaryColor?.withAlphaComponent(0.7)
    }
    
    func validateInfo() {
        if isEmailValid == false {
            AlertMessage.showAlertMessage("Invalid Email", "Please enter valid email", self)
            
        } else if isPasswordValid == false {
            AlertMessage.showAlertMessage("Invalid Password", "Password must contain at least 8 letters", self)
            
        }
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
