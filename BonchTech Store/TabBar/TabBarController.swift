//
//  TabBarViewController.swift
//  BonchTech Store
//
//  Created by Nikita Voronov on 19.05.2023.
//

import UIKit
import FirebaseAuth

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        isUserAuthenticated { isAuthenticated in
            if isAuthenticated {
                self.showUserProfile()
            } else {
                self.showRegistrationScreen()
            }
        }
    }
    
    func isUserAuthenticated(completion: @escaping (Bool) -> Void) {
        Auth.auth().addStateDidChangeListener { (_, user) in
            if user == nil {
                completion(false)
            } else {
                completion(true)
            }
        }
    }

    private func showUserProfile() {
        let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuthorizedVC")
        let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainVC")
        let catalogVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "catalogVC")
        let cartVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cartVC")
        
        mainVC.tabBarItem = UITabBarItem(title: "Главная", image: UIImage(named: "profile_icon"), tag: 0)
        catalogVC.tabBarItem = UITabBarItem(title: "Каталог", image: UIImage(named: "profile_icon"), tag: 1)
        cartVC.tabBarItem = UITabBarItem(title: "Корзина", image: UIImage(named: "profile_icon"), tag: 2)
        profileVC.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(named: "profile_icon"), tag: 3)
        
        
        viewControllers = [mainVC, catalogVC, cartVC, profileVC]
    }
    
    private func showRegistrationScreen() {
        let registrationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UnauthorizedVC")
        let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainVC")
        let catalogVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "catalogVC")
        let cartVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cartVC")
        
        mainVC.tabBarItem = UITabBarItem(title: "Главная", image: UIImage(named: "profile_icon"), tag: 0)
        catalogVC.tabBarItem = UITabBarItem(title: "Каталог", image: UIImage(named: "profile_icon"), tag: 1)
        cartVC.tabBarItem = UITabBarItem(title: "Корзина", image: UIImage(named: "profile_icon"), tag: 2)
        registrationVC.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(named: "registration_icon"), tag: 3)
        
        viewControllers = [mainVC, catalogVC, cartVC, registrationVC]
    }
}
