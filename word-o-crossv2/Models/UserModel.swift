//
//  UserModel.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 2/9/22.
//

import Foundation

class User: ObservableObject, Codable {
    var userId: String? = ""
    var userName: String = ""
    var email: String = ""
    var pw: String = ""
    
    init(userName: String, email: String, pw: String) {
        self.userId = ""
        self.userName = userName
        self.email = email
        self.pw = pw
    }
}

class CreateUserRequest: ObservableObject, Codable {
    var userName: String = ""
    var email: String = ""
    var pw: String = ""
    
    init(userName: String, email: String, pw: String) {
        self.userName = userName
        self.email = email
        self.pw = pw
    }
}
