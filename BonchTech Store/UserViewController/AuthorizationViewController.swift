//
//  UserViewController.swift
//  BonchTech Store
//
//  Created by Nikita Voronov on 19.05.2023.
//

import UIKit
import Firebase

class AuthorizationViewController: UIViewController, UITextFieldDelegate {
    
    
    
    var signup: Bool = true{
        willSet{
            if newValue{
                titleLabel.text = "Регистрация"
                nameField.isHidden = false
                changeButton.setTitle("Авторизоваться", for: .normal)
                hintLabel.text = "У вас уже есть аккаунт?"
                logInButton.setTitle("Регистрация", for: .normal)
            } else {
                titleLabel.text = "Вход"
                nameField.isHidden = true
                changeButton.setTitle("Зарегистрироваться", for: .normal)
                hintLabel.text = "У вас еще нет аккаунта?"
                logInButton.setTitle("Вход", for: .normal)
            }
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        
        nameField.placeholder = "Имя"
        emailField.placeholder = "e-mail"
        passwordField.placeholder = "Пароль"
        
        titleLabel.text = "Регистрация"
        hintLabel.text = "У вас уже есть аккаунт?"
        changeButton.setTitle("Авторизоваться", for: .normal)
        changeButton.titleLabel?.numberOfLines = 1
        changeButton.tintColor = UIColor.systemOrange
        logInButton.titleLabel?.numberOfLines = 1
        logInButton.layer.cornerRadius = 15
        logInButton.tintColor = .white
        logInButton.backgroundColor = UIColor.systemOrange
        logInButton.setTitle("Регистрация", for: .normal)
    }
    
    @IBAction func registrationButton(_ sender: Any) {
        let name = nameField.text!
        let email = emailField.text!
        let password = passwordField.text!
        
        if signup{
            Auth.auth().createUser(withEmail: email, password: password){ (result, error) in
                if error == nil {
                    print(result!.user.uid)
                    let userId = result!.user.uid
                    APIManager.shared.addUser(name: name, email: email, userId: userId)
                } else {
                    print(error!)
                }
            }
        } else {
            Auth.auth().signIn(withEmail: email, password: password){(result, error) in
                if error == nil{
                }
            }
        }
    }
    
    @IBAction func switchLogin(_ sender: Any) {
        signup = !signup
    }
    
}

//extension UserViewController: UITextFieldDelegate{
//    func textFieldShouldReturn( textField: UITextField){
//        let name = nameField.text!
//        let email = emailField.text!
//        let password = passwordField.text!
//
//        Auth.auth().createUser(withEmail: email, password: password){ (result, error) in
//            if error == nil {
//                print(result?.user.uid)
//            }
//        }
//    }
//}
