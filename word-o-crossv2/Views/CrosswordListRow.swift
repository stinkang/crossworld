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
    
    init(crosswordModel: CrosswordModel, xWordMatch: GKMatch, shouldSendGoBackToLobbyMessage: Binding<Bool>, shouldSendCrosswordData: Binding<Bool>, opponent: Binding<GKPlayer>, connectedStatus: Binding<Bool>)
    {
        self.crosswordModel = crosswordModel
        self.xWordMatch = xWordMatch
        self._shouldSendGoBackToLobbyMessage = shouldSendGoBackToLobbyMessage
        self._shouldSendCrosswordData = shouldSendCrosswordData
        self._opponent = opponent
        self._connectedStatus = connectedStatus
        self.crossword = Crossword(crosswordModel: crosswordModel)
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
            // 1
              crosswordModel.title.map(Text.init)
                  //.font(.)
            HStack {
              // 2
                crosswordModel.author.map(Text.init)
                .font(.caption)
              Spacer()
              // 3
                crosswordModel.editor.map(Text.init)
                .font(.caption)
            }
          }
      }
  }
}
