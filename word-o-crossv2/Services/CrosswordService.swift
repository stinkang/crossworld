//
//  CrosswordService.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 3/17/22.
//

import Foundation
import Firebase

struct CrosswordService {
    func uploadCrosswordLeaderboardWithOneScore(crossword: Crossword, userName: String, score: Int64) {
        let crosswordData = crossword.encodeBackIntoJson()

        let leaderboardScore = LeaderboardScore(userName: userName, score: score)
        
        var scores: [Any] = []
        let scoreToAdd: [String: Any] = [
                "userName": userName,
                "score": score
            ]
        scores.append(scoreToAdd)

        if (crosswordData != nil) {
            let data = [
                "crossword": crosswordData!,
                "scores": scores
            ] as [String : Any]
            let ref = Firestore.firestore().collection("crosswordLeaderboards").document()

            ref.setData(data) { _ in print("DEBUG: Did upload crossword leederbort") }
            
//            ref.updateData([
//                "scores": FieldValue.arrayUnion([leaderboardScoreData!])
//            ]) { _ in print("DEBUG: Did updates scores") }
        }
    }
    
    func updateCrosswordLeaderboard(leaderboardId: String) {

        //Firestore.firestore().collection("crosswordLeaderboards").doc(leaderboardId).update({"blah": 3});
    }
    
    func uploadCrosswordCompletedPost() {
        
    }
    
    func fetchCrosswordLeaderboards(completion: @escaping([CrosswordLeaderboard]) -> Void) {
        Firestore.firestore().collection("crosswordLeaderboards").getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            
//            do {
//                try documents[0].data(as: CrosswordLeaderboard.self)
//            } catch {
//                print(error)
//            }
            let crosswordLeaderboards = documents.compactMap({ try? $0.data(as: CrosswordLeaderboard.self)})
            completion(crosswordLeaderboards)
        }
    }
    
    func fetchCrosswordCompletedPosts() {
        
    }
    
    func fetchCrosswords() {
        Firestore.firestore().collection("crosswords").getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            
            documents.forEach { doc in
                print(doc.documentID)
                print(doc.data())
            }
        }
    }
}
