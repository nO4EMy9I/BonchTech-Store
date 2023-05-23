//
//  OrderViewController.swift
//  BonchTech Store
//
//  Created by Nikita Voronov on 11.05.2023.
//

import UIKit

class OrderViewController: UIViewController {
    
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var phoneNumberTextField: UITextField!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!

    var boughtProductsList = [Product]()
    var idBoughtProducts = [Int]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameTextField.delegate = self
        self.phoneNumberTextField.delegate = self
        self.cityTextField.delegate = self
        self.addressTextField.delegate = self
    }
    
    
    
    @IBAction func placeAnOrder(_ sender: Any) {
        
        order()
    }
    
    func order(){
        guard !errorAlert() else { return }
        
        doneAlert()
        nameTextField.text = ""
        phoneNumberTextField.text = ""
        cityTextField.text = ""
        addressTextField.text = ""
    }
    
    //Стиль aletr
    func alert(title: String, message: String){
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okButton)
        
        present(alert, animated: true, completion: nil)
    }
    
    // Вызов alert с ошибкой
    func errorAlert() -> Bool{
        
        if nameTextField.text == "" || phoneNumberTextField.text == "" || cityTextField.text == "" || addressTextField.text == "" {
            alert(title: "Ошибка", message: "Заполните все поля")
            
            return true
        } else if Int(nameTextField.text!) != nil || Int(phoneNumberTextField.text!) == nil || Int(cityTextField.text!) != nil {

            alert(title: "Ошибка", message: "Заполните поля правильно")
            return true
        } else{
            return false
        }
    }
    
    // Оформление заказа и вызов alert с номером заказа
    func doneAlert(){
        
        let phoneNumber:Int = Int(phoneNumberTextField.text!) ?? 0
        
        var products = [String]()
        
        for product in boughtProductsList{
            
            products.append(product.name)
        }
        
        let orderNumber = APIManager.shared.addDocument(name: nameTextField.text ?? "nil", phoneNumber: phoneNumber, city: cityTextField.text ?? "nil", address: addressTextField.text ?? "nil", idProducts: products)
        
        alert(title: "Номер вашего заказа", message: "№\(orderNumber)")
    }
}

extension OrderViewController: UITextFieldDelegate{
    
    //Скрытие клавиатуры
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        phoneNumberTextField.resignFirstResponder()
        cityTextField.resignFirstResponder()
        addressTextField.resignFirstResponder()
        
        return true
    }
    
}

