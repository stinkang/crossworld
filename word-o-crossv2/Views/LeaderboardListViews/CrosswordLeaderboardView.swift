//
//  CrosswordLeaderboardView.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 3/18/22.
//

import SwiftUI

struct CrosswordLeaderboardView: View {
    @Binding var crosswordLeaderboard: CrosswordLeaderboard
    @Binding var crossword: Crossword
    //@GestureState private var isTapped = false
    var body: some View {
//        let tap = DragGesture(minimumDistance: 0)
//            .updating($isTapped) { (_, isTapped, _) in
//                isTapped = true
//            }

        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(crosswordLeaderboard.crossword.dow).textCase(.uppercase)
                    Text(crosswordLeaderboard.crossword.title)
                    Text("By " + crosswordLeaderboard.crossword.author)
                        .font(.caption)
                    Text("Edited by " + crosswordLeaderboard.crossword.editor)
                        .font(.caption)
                    Spacer()
                }
                    //.frame(minWidth: 0, maxWidth: (UIScreen.screenWidth / 3) * 2)
                    .padding(.leading, 6)
                    .padding(.top, 3)
                Spacer()
                VStack(alignment: .leading) {
                    Text("Leaderboard")
                        .foregroundColor(.gray)
                        .font(.caption)
                        .padding(.bottom, 0)
                    ScrollView {
                        VStack {
                            ForEach(0..<20) { i in
                                HStack {
                                    if (i < crosswordLeaderboard.scores.count) {
                                        Text(String(i + 1) + ". " + crosswordLeaderboard.scores.sorted(by: { $0.score < $1.score })[i].userName)
                                            .font(.caption)
                                        Spacer()
                                        TimerTimeView(secondsElapsed: crosswordLeaderboard.scores.sorted(by: { $0.score < $1.score })[i].score)
                                            .font(.caption)
                                    }
                                }
                                .padding(.trailing, 6)
                            }
                        }
                    }
                }
                .padding(.top, 3)
                .frame(minWidth: 0, maxWidth: UIScreen.screenWidth / 3)
            }
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if (crosswordLeaderboard.crossword.title != crossword.title) {
                crossword = crosswordLeaderboard.crossword
            }
        }
//        .background(isTapped ? .gray : .white)
//        .gesture(tap)
        .frame(height: UIScreen.screenHeight / 8, alignment: .center)
        .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.emptyGray, lineWidth: 1)
                )
        .padding(.bottom, 5)
    }
}

//struct CrosswordLeaderboardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CrosswordLeaderboardView()
//    }
//}
