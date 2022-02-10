//
//  UserModel.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 2/9/22.
//

import Foundation

class User: ObservableObject, Codable {
    var id: Int = 0
    var userName: String
    var email: String
    var pw: String
    
    init(userName: String, email: String, pw: String) {
        // TODO: backend should generate new user Id instead and set
        self.id = .random(in: 0..<10000)
        self.userName = userName
        self.email = email
        self.pw = pw
    }
}
