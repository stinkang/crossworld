//
//  CrosswordListRow.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 3/9/22.
//

import SwiftUI
import GameKit

struct CrosswordListRow: View {
    let crosswordModel: CrosswordModel
    var xWordMatch: GKMatch
    @Binding var shouldSendGoBackToLobbyMessage: Bool
    @Binding var shouldSendCrosswordData: Bool
    @Binding var opponent: GKPlayer
    @Binding var connectedStatus: Bool
    @State var crossword: Crossword
    var numberFormatter: NumberFormatter
    
    init(crosswordModel: CrosswordModel, xWordMatch: GKMatch, shouldSendGoBackToLobbyMessage: Binding<Bool>, shouldSendCrosswordData: Binding<Bool>, opponent: Binding<GKPlayer>, connectedStatus: Binding<Bool>)
    {
        self.crosswordModel = crosswordModel
        self.xWordMatch = xWordMatch
        self._shouldSendGoBackToLobbyMessage = shouldSendGoBackToLobbyMessage
        self._shouldSendCrosswordData = shouldSendCrosswordData
        self._opponent = opponent
        self._connectedStatus = connectedStatus
        self.crossword = Crossword(crosswordModel: crosswordModel)
        self.numberFormatter  = NumberFormatter()
        numberFormatter.minimumIntegerDigits = 2
    }

  var body: some View {
      NavigationLink(destination:
        XWordView(
            crossword: crossword,
            crosswordBinding: $crossword,
            xWordMatch: xWordMatch,
            shouldSendGoBackToLobbyMessage: $shouldSendGoBackToLobbyMessage,
            shouldSendCrosswordData: $shouldSendCrosswordData,
            opponent: $opponent,
            connectedStatus: $connectedStatus
        )
      ) {
          VStack(alignment: .leading) {
              HStack {
                  VStack(alignment: .leading) {
                      crosswordModel.title.map(Text.init)
                      crosswordModel.author.map(Text.init)
                          .font(.caption)
                      crosswordModel.editor.map(Text.init)
                          .font(.caption)
                  }
                  Spacer()
                  let hours = (crosswordModel.secondsElapsed % 86400) / 3600
                  let minutes = (crosswordModel.secondsElapsed % 3600) / 60
                  let seconds = (crosswordModel.secondsElapsed % 3600) % 60
                  Text("\(numberFormatter.string(from: NSNumber(value: hours))!):\(numberFormatter.string(from: NSNumber(value: minutes))!):\(numberFormatter.string(from: NSNumber(value: seconds))!)")
                      .font(.caption)
                      .foregroundColor(crosswordModel.solved ? .green : .yellow)
                  if (crosswordModel.solved) {
                      Image(systemName: "checkmark.circle.fill")
                          .foregroundColor(.green)
                          .frame(width: 12, height: 12)
                  } else {
                      Circle()
                          .trim(from: 0.0, to: CGFloat(crosswordModel.percentageComplete))
                          .rotation(.degrees(270))
                          .stroke(Color.green ,style: StrokeStyle(lineWidth: 2, lineCap: .butt))
                          .frame(width: 12, height: 12)
                  }
              }
          }
      }
  }
}
