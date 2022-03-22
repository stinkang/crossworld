//
//  LeaderboardsView.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 3/17/22.
//

import SwiftUI

struct LeaderboardListView: View, Equatable {
    @ObservedObject var viewModel = CrosswordLeaderboardViewModel()
    @Binding var crossword: Crossword
    let crosswordService = CrosswordService()
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.crosswordLeaderboards) { crosswordLeaderboard in
                    CrosswordLeaderboardView(crosswordLeaderboard: crosswordLeaderboard, crossword: $crossword)
                }
            }
        }
    }
    
    static func == (lhs: LeaderboardListView, rhs: LeaderboardListView) -> Bool {
        return true
    }
}
//
//struct LeaderboardListView_Previews: PreviewProvider {
//    static var previews: some View {
//        LeaderboardListView()
//    }
//}
