//
//  StringExtensions.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 2/9/22.
//

import Foundation

extension String {
    var isValidEmail: Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return count < 100 && stringFulfillsRegex(regex: emailFormat)
    }
    
    var isValidUsername: Bool {
        let usernameFormat = "^[a-zA-Z0-9]+$"
        return count < 100 && stringFulfillsRegex(regex: usernameFormat)
    }
    
    var isValidPassword: Bool {
        let passwordFormat = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        return stringFulfillsRegex(regex: passwordFormat)
    }
    
    private func stringFulfillsRegex(regex: String) -> Bool {
        let texttest = NSPredicate(format: "SELF MATCHES %@", regex)
        return texttest.evaluate(with: self)
    }
}
