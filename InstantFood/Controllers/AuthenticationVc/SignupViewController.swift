//
//  SignupViewController.swift
//  InstantFood
//
//  Created by Macbook Pro on 02/07/2024.
//

/* 1-add google package and google sheet.
   2-write code for it
   3-change button image.
   4-*/
import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class SignupViewController: UIViewController {

    @IBOutlet var nameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet weak var registerSegment : UISegmentedControl!
    @IBOutlet weak var signupButton : UIButton!
    
    private var isEmailValid = false
    private var isPasswordValid = false
    private var isNameValid = false
    var signupManager = SignupManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerSegment.selectedSegmentIndex = 0
        registerSegment.setTitleTextAttributes([.foregroundColor : K.lightColor!], for: .selected)
        
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
        
        validateInfo()
        signupManager.signupWithEmail(self, email, password)
    }
    
    @IBAction func googleSignup(_ sender: UIButton) {
        signupManager.signupWithGoogle(self)
    }
    
    @IBAction func facebookSignup(_ sender: UIButton) {
        signupManager.signupWithFacebook(self)
    }
    
    @IBAction func backpressed(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: K.welcomeVCTIdentifier) as? WelcomeViewControllerTwo else { return }
         navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateSignupButton () {
        signupButton.isEnabled = isEmailValid && isPasswordValid && isNameValid
        signupButton.backgroundColor = signupButton.isEnabled ? K.primaryColor : K.primaryColor?.withAlphaComponent(0.7)
    }
    
    func validateInfo() {
        if isEmailValid == false {
            AlertMessage.showAlertMessage("Invalid Email", "Please enter valid email", self)
            
        } else if isNameValid == false {
            AlertMessage.showAlertMessage("Invalid Name", "Name must contain at least 5 alphabets or numbers", self)
            
        } else if isPasswordValid == false {
            AlertMessage.showAlertMessage("Invalid Password", "Password must contain at least 8 letters", self)
            
        }
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

