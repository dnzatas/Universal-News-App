//
//  LoginViewModel.swift
//  UN
//
//  Created by deniz on 21.09.2023.
//

import Foundation
import Firebase

class LoginViewModel {
    var email: String = ""
    var password: String = ""
    
    var showAlert: ((String) -> Void)?
    var navigateToNews: (() -> Void)?
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
            if let error = error {
                self?.showAlert?(error.localizedDescription)
            } else {
                self?.navigateToNews?()
            }
        }
    }
}

