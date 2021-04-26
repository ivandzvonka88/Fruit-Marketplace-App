//
//  SignInViewController.swift
//  berryGO
//
//  Created by Evgeny Gusev on 22.02.2020.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit
import AuthenticationServices
import Firebase
import GoogleSignIn

class SignInViewController: UIViewController, Storyboarded {

  @IBOutlet weak var myView: UIView!
  @IBOutlet weak var closeButton: UIButton!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var signupButton: UIButton!
  @IBOutlet weak var appleloginButton: UIButton!
  @IBOutlet weak var googleloginButton: GIDSignInButton!
  @IBOutlet weak var termButton: UIButton!
  
  @IBOutlet weak var googleSignInButton: GIDSignInButton!
    @IBOutlet weak var signInWithAppleButton: UIButton!
    @IBOutlet weak var emailTextField: BGTextField!
    @IBOutlet weak var passwordTextField: BGTextField!
    @IBOutlet weak var signInButton: UIButton!
    
    var callback: UserManager.FirebaseClosure?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        myView.layer.cornerRadius = 24
    }
    
    @objc private func handleLogInWithAppleIDButtonPress() {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
                
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }
    
  @IBAction func appleloginPressed(_ sender: Any) {
      if #available(iOS 13.0, *) {
          let appleIDProvider = ASAuthorizationAppleIDProvider()
          let request = appleIDProvider.createRequest()
          request.requestedScopes = [.fullName, .email]
              
          let authorizationController = ASAuthorizationController(authorizationRequests: [request])
          authorizationController.delegate = self
          authorizationController.presentationContextProvider = self
          authorizationController.performRequests()
      }
  }
  
  @IBAction func googleloginPressed(_ sender: Any) {
      GIDSignIn.sharedInstance().signIn()
  }
  @IBAction func signInPressed(_ sender: Any) {
      let loginVC = LoginViewController.instantiate(fromStoryboard: "SignIn")
      navigationController?.pushViewController(loginVC, animated: true)
  }
  
  @IBAction func closeTapped(_ sender: Any) {
      self.dismiss(animated: true, completion: nil)
  }
  @IBAction func termPressed(_ sender: Any) {
  
  }
  @IBAction func signUpPressed(_ sender: Any) {
        let registrationVC = SignupOneViewController.instantiate(fromStoryboard: "SignIn")
        navigationController?.pushViewController(registrationVC, animated: true)
    }
}

@available(iOS 13.0, *)
extension SignInViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let appleIDToken = appleIDCredential.identityToken,
                let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      accessToken: nil)
            
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let uid = authResult?.user.uid else {
                    self.navigationController?.dismiss(animated: true)
                    return
                }
                
                UserManager.loadLikedFruits { (_) in
                    self.navigationController?.dismiss(animated: true) {
                        guard let callback = self.callback else {
                            return
                        }
                        NotificationCenter.default.post(Notification(name: AppDelegate.userDataChanged))
                        callback(uid)
                    }
                }
            }
        }
    }
}

@available(iOS 13.0, *)
extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension SignInViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }

        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let uid = authResult?.user.uid else {
                self.navigationController?.dismiss(animated: true)
                self.dismiss(animated: true, completion: nil)
                return
            }
            
            UserManager.loadLikedFruits { (_) in
                self.navigationController?.dismiss(animated: true) {
                    guard let callback = self.callback else {
                        return
                    }
                    NotificationCenter.default.post(Notification(name: AppDelegate.userDataChanged))
                    callback(uid)
                }
            }
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}
