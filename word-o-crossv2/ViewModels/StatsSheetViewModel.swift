//
//  StatSheetViewModel.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 8/18/22.
//

import Foundation

class StatsSheetViewModel: ObservableObject {
    @Published var crosswordLeaderboards = [CrosswordLeaderboard]()
    let service = FirebaseService()
    
    init(leaderboardId: String) {
        getCrosswordLeaderboard(leaderboardId: leaderboardId)
    }
    
    public func getCrosswordLeaderboard(leaderboardId: String) {
        service.getCrosswordLeaderboard(leaderboardId: leaderboardId) { crosswordLeaderboard in
            self.crosswordLeaderboards.append(crosswordLeaderboard)
        }
    }
}
