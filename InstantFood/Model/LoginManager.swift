//
//  LoginManager.swift
//  InstantFood
//
//  Created by Macbook Pro on 05/07/2024.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

struct LoginManager {
    
    
    // MARK: - loginWithEmail
    func loginWithEmail (_ vc : UIViewController, _ email : String, _ password : String){
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if error == nil {
                guard let pvc = vc.storyboard?.instantiateViewController(withIdentifier: K.preferencesVCIdentifier) as? PreferencesViewController else { return }
                vc.navigationController?.pushViewController(pvc, animated: true)
            } else {
                AlertMessage.showAlertMessage("Account do not exist.", "This account do not exist.you can create a new account.", vc)
            }
        }
    }
    
    
    // MARK: -  Google Sign in
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
                    return }
                guard let pvc = vc.storyboard?.instantiateViewController(withIdentifier: "vc") as? ViewController else { return }
                        vc.navigationController?.pushViewController(pvc, animated: true)
                    }
                }
            }
        }

