//
//  UserLoginViewModel.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 2/9/22.
//

import Foundation

class UserViewModel: ObservableObject {
    @Published var userName = ""
    @Published var pw = ""
    @Published var email = ""
    @Published var errorMessage = ""
    @Published var hidePassword = true
    @Published var currentUserId = 0
    @Published var currentUserName = ""
    
    func login() -> Bool {
        errorMessage = ""
        if (email.isEmpty) {
            errorMessage = "Email is empty"
            return false
        }
        if (userName.isEmpty) {
            errorMessage = "Username is empty"
            return false
        }
        if (pw.isEmpty) {
            errorMessage = "Password is empty"
            return false
        }
        if (false/*validate from backend*/) {
            errorMessage = "No user with such credentials exists."
            return false
        }
        // get User from backend instead
        let user = User(userName: "loggedInGuy", email: "loganlogin@gmail.com", pw: "poopypassword1")
        currentUserId = user.id
        currentUserName = user.userName
        return true
    }
    
    func createUser() -> Bool {
        errorMessage = ""
        if (email.isEmpty) {
            errorMessage = "Email is empty"
            return false
        }
        if (userName.isEmpty) {
            errorMessage = "Username is empty"
            return false
        }
        if (pw.isEmpty) {
            errorMessage = "Password is empty"
            return false
        }
        if (!userName.isValidUsername) {
            errorMessage = "Username must be alphanumeric"
            return false
        }
        if (!pw.isValidPassword) {
            errorMessage = "Passwords must be a minimum of 8 characters "
                            + "with at least one letter and one number."
            return false
        }
        if (!email.isValidEmail) {
            errorMessage = "Email is not valid"
            return false
        }
        // TODO: send this object to the backend
        let user = User(userName: userName, email: email, pw: pw)
        currentUserId = user.id
        return true
    }
    
    func logOut() -> Bool {
        currentUserId = 0
        currentUserName = ""
        return true
    }
}
