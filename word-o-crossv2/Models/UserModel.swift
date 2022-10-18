//
//  c.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 10/14/22.
//

import Foundation

import FirebaseFirestoreSwift
import Firebase

struct UserModel: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var uid: String
    var email: String?
    var photoURL: URL?
    var displayName: String?
    
    static func == (lhs: UserModel, rhs: UserModel) -> Bool {
        return lhs.uid == rhs.uid
            && lhs.email == rhs.email
            && lhs.photoURL == rhs.photoURL
            && lhs.displayName == rhs.displayName
    }
}
