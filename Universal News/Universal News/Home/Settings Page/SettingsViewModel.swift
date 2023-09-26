import Foundation
import Firebase

struct UserData {
    var name: String
}

class SettingsViewModel {
    func loadUserData(currentUser: User, completion: @escaping (UserData) -> Void) {
        let db = Firestore.firestore()
        let userDocument = db.collection("users").document(currentUser.uid)

        userDocument.getDocument { (document, error) in
            if let document = document, document.exists {
                if let userData = document.data() {
                    if let name = userData["name"] as? String {
                        let userData = UserData(name: name)
                        completion(userData)
                    }
                }
            } else {
                print("User document does not exist")
            }
        }
    }

    func saveChanges(password: String, updatedName: String?, updatedEmail: String?, completion: @escaping (Bool, String) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(false, "User not authenticated")
            return
        }

        let credential = EmailAuthProvider.credential(withEmail: currentUser.email!, password: password)
        currentUser.reauthenticate(with: credential) { (authResult, error) in
            if let error = error {
                completion(false, "Authentication Failed: \(error.localizedDescription)")
            } else {
                let updatedName = updatedName ?? ""
                let updatedEmail = updatedEmail ?? ""

                let changeRequest = currentUser.createProfileChangeRequest()
                changeRequest.displayName = updatedName
                changeRequest.commitChanges { error in
                    if let error = error {
                        completion(false, "Failed to update name: \(error.localizedDescription)")
                    } else {
                        currentUser.updateEmail(to: updatedEmail) { error in
                            if let error = error {
                                completion(false, "Failed to update email: \(error.localizedDescription)")
                            } else {
                                let db = Firestore.firestore()
                                let userDocument = db.collection("users").document(currentUser.uid)
                                userDocument.updateData(["name": updatedName, "email": updatedEmail]) { error in
                                    if let error = error {
                                        completion(false, "Failed to update user data: \(error.localizedDescription)")
                                    } else {
                                        completion(true, "Success")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func logout(completion: @escaping (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch {
            completion(false)
        }
    }
}

