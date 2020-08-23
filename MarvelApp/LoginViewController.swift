//
//  LoginViewController.swift
//  MarvelApp
//
//  Created by Guilherme Takakuwa on 23/08/20.
//  Copyright © 2020 Guilherme Takakuwa. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextEdit: UITextField!
    @IBOutlet weak var passwordTextEdit: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        self.emailTextEdit.layer.borderWidth = 1
        self.emailTextEdit.layer.borderColor = UIColor.black.cgColor
        
        self.passwordTextEdit.layer.borderWidth = 1
        self.passwordTextEdit.layer.borderColor = UIColor.black.cgColor
        
        self.loginButton.layer.borderWidth = 1
        self.loginButton.layer.borderColor = UIColor.black.cgColor
        
        self.registerButton.layer.borderWidth = 1
        self.registerButton.layer.borderColor = UIColor.black.cgColor
    }
    
    func validateFields() -> Bool {
        var isValid = true
        
        if(!self.isValidEmail(self.emailTextEdit.text!)){
            isValid = false
        }
        
        if(!self.isValidPassword(self.passwordTextEdit.text!)){
            isValid = false
        }
        
        return isValid
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }
    
    @IBAction func loginButtonTouchUpInside(_ sender: Any) {
        let validFields = self.validateFields()
        
        let userInfoKey = self.emailTextEdit.text! + self.passwordTextEdit.text!
        let defaults = UserDefaults.standard
        let allKeys =  Array(defaults.dictionaryRepresentation().keys)
        
        if(validFields){
            var emailIsRegistered:Bool = false
            
            for key in allKeys {
                if(key.contains(self.emailTextEdit.text!)){
                    emailIsRegistered = true
                }
            }
            
            let userInfo = defaults.object(forKey: userInfoKey)
            
            if(userInfo != nil){
                let ListCharactersTableViewController = self.storyboard!.instantiateViewController(withIdentifier: "ListCharactersTableViewController") as! ListCharactersTableViewController
                self.navigationController!.pushViewController(ListCharactersTableViewController, animated: true)
            }else{
                if(!emailIsRegistered){
                    let alert = UIAlertController(title: "Erro", message: "Email não cadastrado", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else if (userInfo == nil){
                    let alert = UIAlertController(title: "Erro", message: "Senha incorreta", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }else{
            let alert = UIAlertController(title: "Erro", message: "Verifique os campos de dados", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

