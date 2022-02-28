//
//  StatsSheetView.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 2/27/22.
//

import SwiftUI

struct StatsSheetView: View {
    var crossword: Crossword
    @ObservedObject var xWordViewModel: XWordViewModel
    var body: some View {
        let numberOfSquaresSolvedByMe = xWordViewModel.squareModels.filter { $0.solvedByMe == true }.count
        let numberOfTotalSquares = xWordViewModel.totalSpaces
        VStack {
            Text("You did it!").font(.title)
                .padding()
            Text("Stats:")
                .padding()
            HStack {
                VStack {
                    Text("You:")
                    Text(String(Float(numberOfSquaresSolvedByMe) / Float(numberOfTotalSquares) * 100) + " %")
                        .foregroundColor(.green)
                }
                Spacer()
                VStack {
                    Text("Them:")
                    Text(String((Float(numberOfTotalSquares - numberOfSquaresSolvedByMe)) / Float(numberOfTotalSquares) * 100) + " %")
                        .foregroundColor(.green)
                }
            }
        }
    }
}

//struct StatsSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        StatsSheetView()
//    }
//}
