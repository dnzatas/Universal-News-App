//
//  SignUpViewModel.swift
//  UN
//
//  Created by deniz on 21.09.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class SignUpViewModel {
    func signUp(email: String, password: String, fullName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let user = Auth.auth().currentUser {
                    let uid = user.uid
                    let db = Firestore.firestore()
                    db.collection("users").document(uid).setData(["name": fullName]) { error in
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            completion(.success(()))
                        }
                    }
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "User is not authenticated"])))
                }
            }
        }
    }
}
