//
//  StringExtensions.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 2/9/22.
//

import Foundation

extension String {
    var isValidEmail: Bool {
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        //let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
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
