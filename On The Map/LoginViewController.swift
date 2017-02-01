//
//  LoginViewController.swift
//  On The Map
//
//  Created by Anirudh Ramanan on 29/01/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loaderIndicator: UIActivityIndicatorView!
    
    var textFieldDelegate = LoginViewTextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFieldDelegate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textFieldDelegate.subscribeToKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        textFieldDelegate.unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func signup(_ sender: Any) {
        UIApplication.shared.open(NSURL(string:"https://auth.udacity.com/sign-up") as! URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func login(_ sender: Any) {
        checkAndPerformLogin()
    }
}

extension LoginViewController{
    
    private func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: usernameTextField.text)
    }
    
    private func isValidPassword() -> Bool{
        let count = passwordTextField.text?.characters.count ?? 0
        return count > 5
    }
    
    func configureTextFieldDelegate() {
        textFieldDelegate.view = self.view
        usernameTextField.delegate = textFieldDelegate
        passwordTextField.delegate = textFieldDelegate
    }
    
    func configureUI(enabled: Bool) {
        usernameTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        loginButton.isEnabled = enabled
        loaderIndicator.isHidden = enabled
    }
    
    func checkAndPerformLogin() {
        let username = usernameTextField.text
        let password = passwordTextField.text
        let networkAvailable = NetworkConnectivityManager.isInternetAvailable()
        
        if isValidEmail() && isValidPassword() && networkAvailable {
            configureUI(enabled: false)
            NetworkClient.sharedInstance().authenticateUser(username: username!, password: password!,  completionHandlerForAuth: { (success, error) in
                self.configureUI(enabled: true)
                if success {
                    let controller = self.storyboard!.instantiateViewController(withIdentifier: "OnTheMapTabController") as! UITabBarController
                    self.present(controller, animated: true, completion: nil)
                } else {
                    self.configureUI(enabled: true)
                    ViewHelper.showAlertForIncorrectState(message: error, showView: {
                        alert in
                        self.present(alert, animated: true, completion: nil)
                    })
                }
            })
        } else if !networkAvailable{
            ViewHelper.showAlertForIncorrectState(message: "No Interent Connectivity. Connect to a working internet connection", showView: {
                alert in
                self.present(alert, animated: true, completion: nil)
            })
        } else {
            ViewHelper.showAlertForIncorrectState(message: "Enter a valid Email Address / Password", showView: {
                alert in
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
}
