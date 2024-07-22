//
//  SignupViewController.swift
//  InstantFood
//
//  Created by Macbook Pro on 02/07/2024.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import KeychainSwift

class SignupViewController: UIViewController {

    
// MARK: - IBOutlets
    @IBOutlet var nameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet weak var registerSegment : UISegmentedControl!
    @IBOutlet weak var signupButton : UIButton!
    
    
// MARK: - Variables
    private var isEmailValid = false
    private var isPasswordValid = false
    private var isNameValid = false
    var signupManager = SignupManager()
    
    
// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerSegment.selectedSegmentIndex = 0
        registerSegment.setTitleTextAttributes([.foregroundColor : UIColor.white], for: .selected)
        
        navigationItem.hidesBackButton = true
        updateSignupButton()
    }
    
 
    
// MARK: - Buttons
    @IBAction func registerSegment(_ sender: UISegmentedControl) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: K.loginVCIdentifier) as? LoginViewController else { return }
         navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func signupClicked(_ sender: UIButton) {
        guard let email = emailField.text,
              let password = passwordField.text else { return }
        signupManager.signupWithEmail(self, email, password)
    }
    
    
    @IBAction func googleSignup(_ sender: UIButton) {
        signupManager.signupWithGoogle(self)
    }
    
    
    @IBAction func backpressed(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: K.welcomeVCTIdentifier) as? WelcomeViewControllerTwo else { return }
         navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
// MARK: - Functions
    func updateSignupButton () {
        signupButton.isEnabled = isEmailValid && isPasswordValid && isNameValid
        signupButton.backgroundColor = signupButton.isEnabled ? K.primaryColor : K.primaryColor?.withAlphaComponent(0.7)
    }
}



// MARK: - TextFieldDelegate
//so it continuously checks validation of password,email and name
extension SignupViewController : UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if textField == emailField {
            isEmailValid = signupManager.isEmailValid(textField.text ?? "")
            
        } else if textField == passwordField {
            isPasswordValid = signupManager.isPasswordValid(textField.text ?? "")
            
        } else if textField == nameField {
            isNameValid = signupManager.isNameValid(textField.text ?? "")
            
        }
        updateSignupButton()
    }
}

