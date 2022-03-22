//
//  CrosswordLeaderboardViewModel.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 3/17/22.
//

import Foundation

class CrosswordLeaderboardViewModel: ObservableObject {
    @Published var crosswordLeaderboards = [CrosswordLeaderboard]()
    let service = CrosswordService()
    
    init() {
        fetchCrosswordLeaderboards()
    }
    
    func fetchCrosswordLeaderboards() {
        service.fetchCrosswordLeaderboards { crosswordLeaderboards in
            self.crosswordLeaderboards = crosswordLeaderboards
        }
    }
}
