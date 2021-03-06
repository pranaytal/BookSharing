//
//  LoginViewController.swift
//  AppX
//
//  Created by Pranay Kumar on 04/07/16.
//  Copyright © 2016 Pranay Kumar. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let gradientLayer = CAGradientLayer()
    let keyChain = KeychainSwift()
    let cSpinner = CustomSpinner(text: Constants.SIGNING_IN_TEXT)
    //var currentUser : User? = nil
    var status: LoginViewStatus? = nil

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var passwordFeild: UITextField!
    @IBOutlet var usernameFeild: UITextField!
    @IBOutlet var signInButton: UIButton!
    
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }

    @IBAction func signInButton(_ sender: Any) {
        
        let loginRequest = LoginRequest(username: "string", password: "string")
        let aFLogin = AFLogin()
        
        aFLogin.login(userDetails: loginRequest, completion: { (loginResponse) -> Void in
            
            guard loginResponse != nil else{
                print("no response from AFLogin.login")
                return
            }
            let unwrappedLoginResponse = loginResponse!
            if case .Success(let loginResponseSuccess) = unwrappedLoginResponse{
                //print(loginResponseSuccess.data)
                setUserCredentialsToKeyChain(authenticationToken: loginResponseSuccess.data)
                self.dismiss(animated: true, completion: nil)
            }else if case .Failure(let loginResponseFailure) = unwrappedLoginResponse{
                print(loginResponseFailure.message)
            }
            return
        })

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureGradientBackground(currentViewController: self, colors: UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 1.0).cgColor, UIColor.white.cgColor)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if status == nil || status == LoginViewStatus.signingIn{
            displaySigningInScreen()
            
        }else{
            displayLoginScreen()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func displaySigningInScreen() {
        self.view.addSubview(cSpinner)
        self.titleLabel.alpha = 0
        self.usernameFeild.alpha = 0
        self.passwordFeild.alpha = 0
        self.signInButton.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.titleLabel.alpha=1
        })
    }
    
    func displayLoginScreen() {
        UIView.animate(withDuration: 0.5, animations: {
            self.cSpinner.alpha = 0
            self.titleLabel.alpha = 1
            self.usernameFeild.alpha = 1
            self.passwordFeild.alpha = 1
            self.signInButton.alpha = 1
        })
        cSpinner.hide()
    }
    
    func login(userName : String?, password : String?) throws -> String? {
        
        var authenticationToken : String? = nil;

        let loginRequest = LoginRequest(username: "string", password: "string")
        
        let aFLogin = AFLogin()
        aFLogin.login(userDetails: loginRequest, completion: { (loginResponse) -> Void in
            guard loginResponse != nil else{
                print("no response from AFLogin.login")
                return
            }
            let unwrappedLoginResponse = loginResponse!
            if case .Success(let loginResponseSuccess) = unwrappedLoginResponse{
                print(loginResponseSuccess.data)
                authenticationToken = loginResponseSuccess.data
                if (authenticationToken != nil){
                    setUserCredentialsToKeyChain(authenticationToken: authenticationToken!)
                    self.dismiss(animated: true, completion: nil)
                }
            }else if case .Failure(let loginResponseFailure) = unwrappedLoginResponse{
                print(loginResponseFailure.message)
            }
            return
        })
        if (authenticationToken != nil){
            setUserCredentialsToKeyChain(authenticationToken: authenticationToken!)
        }
        return authenticationToken
        
    }
    

}
