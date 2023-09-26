//
//  SettingsViewController.swift
//  UN
//
//  Created by deniz on 12.09.2023.
//


import UIKit
import Firebase

class SettingsViewController: UIViewController {
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var switchOutlet: UISwitch!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!

    var viewModel: SettingsViewModel!
    var isEditingEnabled = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.parent?.title = ""
        userNameTextField.isUserInteractionEnabled = false
        userEmailTextField.isUserInteractionEnabled = false

        let isDarkModeEnabled = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
        switchOutlet.isOn = isDarkModeEnabled

        viewModel = SettingsViewModel()
        
        userNameLabel.isHidden = true
        userEmailLabel.isHidden = true

        if let currentUser = Auth.auth().currentUser {
            viewModel.loadUserData(currentUser: currentUser) { [weak self] userData in
                DispatchQueue.main.async {
                    self?.userNameLabel.text = userData.name
                    self?.userNameTextField.text = userData.name
                    self?.userEmailLabel.text = currentUser.email
                    self?.userEmailTextField.text = currentUser.email
                    
                    self?.userNameLabel.isHidden = false
                    self?.userEmailLabel.isHidden = false
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.parent?.title = ""
    }

    @IBAction func switchClicked(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "isDarkModeEnabled")

        if sender.isOn {
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .dark
            }
            modeLabel.text = "Light Mode"
        } else {
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light
            }
            modeLabel.text = "Dark Mode"
        }
    }

    @IBAction func editButtonClicked(_ sender: Any) {
        if isEditingEnabled {
            let alertController = UIAlertController(title: "Authentication Required", message: "Please enter your password to save changes.", preferredStyle: .alert)
            alertController.addTextField { textField in
                textField.placeholder = "Password"
                textField.isSecureTextEntry = true
            }

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
                if let password = alertController.textFields?.first?.text {
                    self?.viewModel.saveChanges(password: password, updatedName: self?.userNameTextField.text, updatedEmail: self?.userEmailTextField.text) { [weak self] success, message in
                        DispatchQueue.main.async {
                            if success {
                                self?.showToast(message: message)
                                self?.userEmailLabel.text = self?.userEmailTextField.text
                                self?.userNameLabel.text = self?.userNameTextField.text
                            } else {
                                self?.showAlert("Error", message: message)
                            }
                            self?.isEditingEnabled = false
                            self?.userNameTextField.isUserInteractionEnabled = false
                            self?.userEmailTextField.isUserInteractionEnabled = false
                            self?.editButton.setTitle("Edit", for: .normal)
                        }
                    }
                }
            }

            alertController.addAction(cancelAction)
            alertController.addAction(saveAction)

            present(alertController, animated: true, completion: nil)
        } else {
            isEditingEnabled.toggle()
            userNameTextField.isUserInteractionEnabled = isEditingEnabled
            userEmailTextField.isUserInteractionEnabled = isEditingEnabled
            editButton.setTitle(isEditingEnabled ? "Save" : "Edit", for: .normal)
        }
    }

    @IBAction func logoutButtonClicked(_ sender: UIButton) {
        viewModel.logout { [weak self] success in
            if success {
                let storyboard = UIStoryboard(name: Constants.Storyboard.login, bundle: nil)
                let loginController = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllers.loginViewController) as! LoginViewController
                loginController.modalPresentationStyle = .fullScreen
                loginController.modalTransitionStyle = .crossDissolve
                self?.present(loginController, animated: true, completion: nil)
            } else {
                self?.showAlert("Error", message: "Could not log out")
            }
        }
    }

    func showAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(cancelAction)
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
            toastLabel.alpha = 0.0 })
    }
}
