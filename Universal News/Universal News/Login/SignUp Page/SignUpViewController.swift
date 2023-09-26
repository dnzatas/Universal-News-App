//
//  SignUpViewController.swift
//  UN
//
//  Created by deniz on 11.09.2023.
//


import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var toLoginButton: UIButton!
    
    let viewModel = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupToLoginButton()
    }
    
    func setupToLoginButton(){
        let attributedString = NSMutableAttributedString(string: "Already have an account? Login")
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.darkGray
        ]
        attributedString.addAttributes(attributes, range: NSRange(location: 25, length: 5))
        toLoginButton.setAttributedTitle(attributedString, for: .normal)
    }
    
    @IBAction func signUpButtonClicked(_ sender: UIButton) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let fullName = fullNameTextField.text else {
            return
        }
        
        viewModel.signUp(email: email, password: password, fullName: fullName) { result in
            switch result {
            case .success:
                self.showToast(message: "Success")
            case .failure(let error):
                self.showAlert(error.localizedDescription)
                self.fullNameTextField.text = ""
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
            }
        }
    }
    
    @IBAction func toLoginButtonClicked(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Constants.Storyboard.login, bundle: nil)
        let loginController = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllers.loginViewController) as! LoginViewController
        loginController.modalPresentationStyle = .fullScreen
        self.present(loginController, animated: true, completion: nil)
    }
    
    func showAlert(_ message: String){
        let alertController = UIAlertController(title: "Sign Up Error", message: message, preferredStyle: .alert)
        let iptalAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(iptalAction)
        present(alertController, animated: true)
    }
    
    func showToast(message: String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.width - 300, y: self.view.frame.height - 510, width: 200, height: 200))
        toastLabel.textAlignment = .center
        toastLabel.backgroundColor = UIColor.clear.withAlphaComponent(0.2)
        toastLabel.textColor = UIColor.white
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 5
        toastLabel.clipsToBounds = true
        
        let checkmarkImageView = UIImageView(image: UIImage(named: "tick"))
        checkmarkImageView.frame = CGRect(x: (toastLabel.frame.width - 60) / 2, y: 30, width: 70, height: 70)
        
        let messageLabel = UILabel(frame: CGRect(x: 50, y: checkmarkImageView.frame.maxY + 10, width: toastLabel.frame.width - 20, height: 80))
        messageLabel.textAlignment = .justified
        messageLabel.textColor = UIColor.white
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFont(ofSize: 28)
        
        toastLabel.addSubview(checkmarkImageView)
        toastLabel.addSubview(messageLabel)
        
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 2.0, delay: 1.0, options: .curveEaseInOut, animations: {
            toastLabel.alpha = 0.0
        }) { (isCompleted) in
            toastLabel.removeFromSuperview()
            let storyboard = UIStoryboard(name: Constants.Storyboard.login, bundle: nil)
            let loginController = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllers.loginViewController) as! LoginViewController
            loginController.modalPresentationStyle = .fullScreen
            self.present(loginController, animated: true, completion: nil)
        }
    }
}
