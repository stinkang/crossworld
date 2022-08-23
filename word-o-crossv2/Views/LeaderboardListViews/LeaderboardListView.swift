//
//  LeaderboardsView.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 3/17/22.
//

import SwiftUI

struct LeaderboardListView: View/*, Equatable*/ {
    @StateObject var viewModel = CrosswordLeaderboardViewModel()
    @Binding var crossword: Crossword
    let crosswordService = FirebaseService()
    var body: some View {
        List($viewModel.crosswordLeaderboards) { $crosswordLeaderboard in
            CrosswordLeaderboardView(crosswordLeaderboard: $crosswordLeaderboard, crossword: $crossword)
                .listRowSeparator(.hidden)
        }
        .navigationBarTitle("CrossWorld!", displayMode: .inline)
        .frame(maxWidth: .infinity)
        .edgesIgnoringSafeArea([.leading, .trailing])
        .listStyle(.plain)
        .refreshable {
            viewModel.fetchCrosswordLeaderboards()
        }
    }
    
//    static func == (lhs: LeaderboardListView, rhs: LeaderboardListView) -> Bool {
//        return lhs.viewModel.crosswordLeaderboards == rhs.viewModel.crosswordLeaderboards
//    }
    
    private func refreshList() {
        print("refreshing...")
    }
}
//
//struct LeaderboardListView_Previews: PreviewProvider {
//    static var previews: some View {
//        LeaderboardListView()
//    }
//}
