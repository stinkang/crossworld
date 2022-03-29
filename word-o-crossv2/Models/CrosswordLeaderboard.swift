//
//  CrosswordLeaderboard.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 3/17/22.
//

import Foundation

import FirebaseFirestoreSwift
import Firebase

struct CrosswordLeaderboard: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    let crossword: Crossword
    var scores: Array<LeaderboardScore>
    
    static func == (lhs: CrosswordLeaderboard, rhs: CrosswordLeaderboard) -> Bool {
        return lhs.crossword.title == rhs.crossword.title && lhs.scores.count == rhs.scores.count
    }
}

struct LeaderboardScore: Codable/*, Equatable */{
    let userName: String
    let score: Int64
    
    func encode() -> Data? {
        return try? JSONEncoder().encode(self)
    }
    
//    static func == (lhs: LeaderboardScore, rhs: LeaderboardScore) -> Bool {
//        return lhs.userName == rhs.userName && lhs.score == rhs.score
//    }
}
