//
//  RegisterViewController.swift
//  MarvelApp
//
//  Created by Guilherme Takakuwa on 15/08/20.
//  Copyright © 2020 Guilherme Takakuwa. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameTextEdit: UITextField!
    @IBOutlet weak var emailTextEdit: UITextField!
    @IBOutlet weak var passwordTextEdit: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        self.nameTextEdit.layer.borderWidth = 1
        self.nameTextEdit.layer.borderColor = UIColor.black.cgColor
        
        self.emailTextEdit.layer.borderWidth = 1
        self.emailTextEdit.layer.borderColor = UIColor.black.cgColor

        self.passwordTextEdit.layer.borderWidth = 1
        self.passwordTextEdit.layer.borderColor = UIColor.black.cgColor
        
        self.registerButton.layer.borderWidth = 1
        self.registerButton.layer.borderColor = UIColor.black.cgColor
    }

    func getUserInfo() -> Dictionary<String,String> {
        let name:String = self.nameTextEdit.text!
        let email:String = self.emailTextEdit.text!
        let password:String = self.passwordTextEdit.text!
        let userInfo = ["name":name ,"email":email,"password":password]
        print(userInfo)
        return userInfo
    }
    
    func registerUser(userInfo:Dictionary<String,String>){
        let canPerformRegister = self.validateFields()
        if(canPerformRegister){
            let defaults = UserDefaults.standard
            let userKey:String = userInfo["email"]! + userInfo["password"]!
            defaults.set(userInfo, forKey:userKey)
            let alert = UIAlertController(title: "Sucesso", message: "Cadastro feito com sucesso", preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                self.navigationController?.popViewController(animated: true)
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        
        }else{
            let alert = UIAlertController(title: "Erro", message: "Verifique os campos de dados", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        print("Registered User")
    }
    
    @IBAction func registerButtonTouchUpInside(_ sender: Any) {
        print("Starting Resgister")
        let userInfo = self.getUserInfo()
        self.registerUser(userInfo: userInfo)
        self.navigationController?.popViewController(animated: true)
        print("Poping view")
    }
    
    func validateFields() -> Bool {
        var isValid = true
        
        if(!self.isValidEmail(self.emailTextEdit.text!)){
            isValid = false
        }
        
        if(!self.isValidName(self.nameTextEdit.text!)){
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
    
    func isValidName(_ name: String) -> Bool {
        let nameRegEx = "([A-Z][a-zA-Z]*)"

        let namePred = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return namePred.evaluate(with: name)
    }
       
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

