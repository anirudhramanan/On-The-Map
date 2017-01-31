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
        
    }
    
    @IBAction func login(_ sender: Any) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        if isValidEmail() && isPasswordValid() {
            NetworkClient.sharedInstance().authenticateUser(username: username!, password: password!,  completionHandlerForAuth: { (success, error) in
                if success {
                    DispatchQueue.main.async {
                        let controller = self.storyboard!.instantiateViewController(withIdentifier: "OnTheMapTabController") as! UITabBarController
                        self.present(controller, animated: true, completion: nil)
                    }
                }
            })
        } else{
            showAlertForIncorrectState()
        }
    }
    
    private func configureTextFieldDelegate() {
        textFieldDelegate.view = self.view
        usernameTextField.delegate = textFieldDelegate
        passwordTextField.delegate = textFieldDelegate
    }
}

extension LoginViewController{
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: usernameTextField.text)
    }
    
    func isPasswordValid() -> Bool{
        let count = passwordTextField.text?.characters.count ?? 0
        return count > 5
    }
    
    func showAlertForIncorrectState() {
        let alert = UIAlertController(title: "Error", message: "Enter valid email and password!", preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction(title: "Back", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func loginCompleteHandler() -> () {
        
    }
}
