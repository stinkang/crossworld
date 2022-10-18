//
//  StatsSheetView.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 2/27/22.
//

import SwiftUI

struct StatsSheetView: View {
    var leaderboardId: String
    @Binding var crossword: Crossword
    @ObservedObject var xWordViewModel: XWordViewModel
    @StateObject var statsSheetViewModel: StatsSheetViewModel
    
    init(leaderboardId: String, crossword: Binding<Crossword>, xWordViewModel: XWordViewModel) {
        self.leaderboardId = leaderboardId
        self.xWordViewModel = xWordViewModel
        _crossword = crossword
        _statsSheetViewModel = StateObject(wrappedValue: StatsSheetViewModel(leaderboardId: leaderboardId))
    }

    var body: some View {
//        let numberOfSquaresSolvedByMe = xWordViewModel.squareModels.filter { $0.solvedByMe == true }.count
//        let numberOfTotalSquares = xWordViewModel.totalSpaces
        VStack {
            Text("You did it!").font(.title)
            if !statsSheetViewModel.crosswordLeaderboards.isEmpty {
                CrosswordLeaderboardView(crosswordLeaderboard: $statsSheetViewModel.crosswordLeaderboards[0], crossword: $crossword)
                    .padding()
            }
//
//            Text("Stats:")
//                .padding()
//            HStack {
//                VStack {
//                    Text("You:")
//                    Text(String(Float(numberOfSquaresSolvedByMe) / Float(numberOfTotalSquares) * 100) + " %")
//                        .foregroundColor(.green)
//                }
//                Spacer()
//                VStack {
//                    Text("Them:")
//                    Text(String((Float(numberOfTotalSquares - numberOfSquaresSolvedByMe)) / Float(numberOfTotalSquares) * 100) + " %")
//                        .foregroundColor(.green)
//                }
//            }
        }
    }
}

//struct StatsSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        StatsSheetView()
//    }
//}
