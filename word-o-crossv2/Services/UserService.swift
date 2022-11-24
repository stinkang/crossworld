//
//  UserService.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 10/14/22.
//

import Foundation
import Firebase

struct UserService {
    
    func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
    
    func getCurrentUserModel() -> UserModel? {
        if let user = getCurrentUser() {
            return UserModel(uid: user.uid, email: user.email, photoURL: user.photoURL, displayName: user.displayName)
        }
        return nil
    }
    
    func updateDisplayName(displayName: String) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = displayName
        changeRequest?.commitChanges { error in
            print("ERROR")
            print(error)
        }
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("error signing out: %@", signOutError)
        }
    }
}
