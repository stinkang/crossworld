//
//  CrosswordLeaderboard.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 3/17/22.
//

import Foundation

import FirebaseFirestoreSwift
import Firebase

struct CrosswordLeaderboard: Identifiable, Codable {
    @DocumentID var id: String?
    let crossword: Crossword
    var scores: Array<LeaderboardScore>
}

struct LeaderboardScore: Codable {
    let userName: String
    let score: Int64
    
    func encode() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
