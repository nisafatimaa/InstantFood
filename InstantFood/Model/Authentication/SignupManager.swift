//
//  SignupManager.swift
//  InstantFood
//
//  Created by Macbook Pro on 05/07/2024.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import KeychainSwift

struct SignupManager {
    
    
    
// MARK: - Variables
    let keychain = KeychainSwift()
    
    
// MARK: - Validation
    func isNameValid(_ name : String) -> Bool {
        guard name.count >= 4 else { return false }
        
        let regex = "[A-Za-z0-9]{5,}"
        //comparing name with criteria
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return namePredicate.evaluate(with: name)
    }
    
    
    func isEmailValid(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    
    func isPasswordValid(_ password: String) -> Bool {
        return password.count >= 7
    }
    
    
    
// MARK: -  Google Sign Up
    func signupWithGoogle(_ vc : UIViewController ) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        //starts sign in flow, here it shows google account to sign in
        GIDSignIn.sharedInstance.signIn(withPresenting: vc) { result, error in
            if error != nil {
                AlertMessage.showAlertMessage("Try later", "Unable to sign up with google", vc)
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            //credentials are used to sign in
            Auth.auth().signIn(with: credential) { result, error in
                if error != nil {
                    AlertMessage.showAlertMessage("Try later", "Unable to sign up with google", vc)
                    return
                } else {
                    if let isNewUser = result?.user.metadata.creationDate,
                       isNewUser == result?.user.metadata.lastSignInDate {
                        
                        keychain.set(idToken, forKey: "authToken")
                        
                        guard let pvc = vc.storyboard?.instantiateViewController(withIdentifier: K.preferencesVCIdentifier) as? PreferencesViewController else { return }
                        vc.navigationController?.pushViewController(pvc, animated: true)
                        
                    } else {
                        AlertMessage.showAlertMessage("Account already exist.", "You can sign in to already present account.", vc)
                    }
                }
            }
        }
    }
    

// MARK: - Email Signup
    func signupWithEmail (_ vc : UIViewController, _ email : String, _ password : String){
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error == nil {
                if let user = authResult?.user, let idToken = user.refreshToken {
                    keychain.set(idToken, forKey: "authToken")
                    print(idToken)
                }
                guard let pvc = vc.storyboard?.instantiateViewController(withIdentifier: K.preferencesVCIdentifier) as? PreferencesViewController else { return }
                vc.navigationController?.pushViewController(pvc, animated: true)
                
            } else if error != nil {
                AlertMessage.showAlertMessage("try Again", "there is server issue.", vc)
            }
        }
    }
}
