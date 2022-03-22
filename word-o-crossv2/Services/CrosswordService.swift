//
//  CrosswordService.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 3/17/22.
//

import Foundation
import Firebase

struct CrosswordService {
    func uploadOrUpdateCrosswordLeaderboard(crossword: Crossword, userName: String, score: Int64) {
        if crossword.leaderboardId == nil {
            uploadCrosswordLeaderboardWithOneScore(crossword: crossword, userName: userName, score: score)
        } else {
            updateCrosswordLeaderboard(leaderboardId: crossword.leaderboardId!, userName: userName, score: score)
        }
    }
    
//    func checkIfLeaderboardWithTitleExists(crossword: Crossword) {
//        let ref = Firestore.firestore().collection("crosswordLeaderboards").whereField("", in: <#T##[Any]#>)
//    }
    
    func uploadCrosswordLeaderboardWithOneScore(crossword: Crossword, userName: String, score: Int64) {
        var crosswordData = crossword.encodeBackIntoJson()
        
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
            crosswordData!["leaderboardId"] = ref.documentID
            
            ref.updateData([
                "crossword": crosswordData!
            ]) { _ in print("DEBUG: Did update crossword leaderboardId") }
        }
    }
    
    func updateCrosswordLeaderboard(leaderboardId: String, userName: String, score: Int64) {

        let ref = Firestore.firestore().collection("crosswordLeaderboards").document(leaderboardId)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                var scores: [Any] = document.data()!["scores"] as! [Any]
                let scoreToAdd: [String: Any] = [
                        "userName": userName,
                        "score": score
                    ]
                scores.append(scoreToAdd)
                ref.updateData([
                    "scores": scores
                ]) { _ in print("DEBUG: Did update crossword scores") }
            } else {
                print("Document does not exist")
            }
        }
    }
//        ref.updateData([
//            "scores":
//        ]) { err in
//            if let err = err {
//                print("Error updating document: \(err)")
//            } else {
//                print("Document successfully updated")
//            }
//        }
    
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
