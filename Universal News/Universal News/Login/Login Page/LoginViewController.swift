//
//  LoginViewController.swift
//  UN
//
//  Created by deniz on 11.09.2023.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginEmailTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    @IBOutlet weak var toSignUpButton: UIButton!
    
    var viewModel: LoginViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupToSignUpButton()
        viewModel = LoginViewModel()
        
        viewModel.showAlert = { [weak self] message in
            self?.showAlert(message)
        }
        
        viewModel.navigateToNews = { [weak self] in
            let storyboard = UIStoryboard(name: Constants.Storyboard.news, bundle: nil)
            let newsTabBarController = storyboard.instantiateViewController(withIdentifier: Constants.TabBarControllers.newsTabBar) as! UITabBarController
            newsTabBarController.modalPresentationStyle = .fullScreen
            self?.present(newsTabBarController, animated: true, completion: nil)
        }
    }
    
    func setupToSignUpButton(){
        let attributedString = NSMutableAttributedString(string: "Dont have an account? Sign up")
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.darkGray
        ]
        attributedString.addAttributes(attributes, range: NSRange(location: 22, length: 7))
        toSignUpButton.setAttributedTitle(attributedString, for: .normal)
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        viewModel.email = loginEmailTextField.text ?? ""
        viewModel.password = loginPasswordTextField.text ?? ""
        viewModel.login()
    }
    
    @IBAction func toSignUpButtonClicked(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Constants.Storyboard.login, bundle: nil)
        let signUpController = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllers.signUpViewController) as! SignUpViewController
        signUpController.modalPresentationStyle = .fullScreen
        self.present(signUpController, animated: true, completion: nil)
    }
    
    func showAlert(_ message: String){
        let alertController = UIAlertController(title: "Login Error", message: message, preferredStyle: .alert)
        let iptalAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(iptalAction)
        present(alertController, animated: true)
    }
}
