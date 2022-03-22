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
        //RefreshableScrollView(action: refreshList) {
            //LazyVStack {
        List(viewModel.crosswordLeaderboards) { crosswordLeaderboard in
            CrosswordLeaderboardView(crosswordLeaderboard: crosswordLeaderboard, crossword: $crossword)
                .listRowSeparator(.hidden)
        }
        .navigationBarTitle("CrossWorld!", displayMode: .inline)
        .frame(maxWidth: .infinity)
        .edgesIgnoringSafeArea([.leading, .trailing])
        .listStyle(.plain)
        .refreshable {
            viewModel.fetchCrosswordLeaderboards()
        }
//                ForEach(viewModel.crosswordLeaderboards) { crosswordLeaderboard in
//                    CrosswordLeaderboardView(crosswordLeaderboard: crosswordLeaderboard, crossword: $crossword)
//                }
            //}
        //}
    }
    
    static func == (lhs: LeaderboardListView, rhs: LeaderboardListView) -> Bool {
        return true
    }
    
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
