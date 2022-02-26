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
    @Published var currentUserId = ""
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
        currentUserId = user.userId!
        currentUserName = user.userName
        return true
    }
    
    func createUser(completion: @escaping (User) -> Void) -> Bool {
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

        let userRequest = CreateUserRequest(userName: userName, email: email, pw: pw)
        var user: User = User(userName: "", email: "", pw: "")
        let userData = try? JSONEncoder().encode(userRequest)
        print(String(data: userData!, encoding: .utf8)!)
        let request = UrlBuilder.createRequest(method: "POST", route: "/user/", body: userData!)
        
        let session = URLSession.shared

        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                // Handle HTTP request error
                self.errorMessage = error.localizedDescription
            } else if let data = data {
                // Handle HTTP request response
                do {
                    user = try JSONDecoder().decode(User.self, from: data)
                } catch DecodingError.dataCorrupted(let context) {
                    print(context)
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.valueNotFound(let value, let context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            } else {
                // Handle unexpected error
            }
            completion(user)
        }
        task.resume()

        if (errorMessage != "") {
            return false
        }

        return true
    }
    
    func logOut() -> Bool {
        currentUserId = ""
        currentUserName = ""
        return true
    }
}
