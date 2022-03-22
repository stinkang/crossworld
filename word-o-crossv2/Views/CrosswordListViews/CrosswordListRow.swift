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
    @Binding var chosenCrossword: Crossword
    @Binding var showArchive: Bool
    @Binding var shouldSendCrosswordData: Bool
    @State private var crosswordForRow: Crossword
    let dateFormatter = DateFormatter()
    
    init(crosswordModel: CrosswordModel, chosenCrossword: Binding<Crossword>, showArchive: Binding<Bool>, shouldSendCrosswordData: Binding<Bool>)
    {
        self.crosswordModel = crosswordModel
        self._chosenCrossword = chosenCrossword
        self._showArchive = showArchive
        self.crosswordForRow = Crossword(crosswordModel: crosswordModel)
        self._shouldSendCrosswordData = shouldSendCrosswordData
        dateFormatter.dateFormat = "MM/dd/YY"
    }

  var body: some View {
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
              VStack(alignment: .trailing) {
                  HStack {
                      TimerTimeView(secondsElapsed: crosswordModel.secondsElapsed)
                          .font(.caption)
                          .foregroundColor(crosswordModel.solved ? .green : .yellow)
                      if (crosswordModel.solved) {
                          Image(systemName: "checkmark.circle.fill")
                              .foregroundColor(.green)
                              .frame(width: 12, height: 12)
                      } else {
                          if (crosswordModel.percentageComplete == 0.0) {
                              Circle()
                                  .stroke(Color.emptyGray ,style: StrokeStyle(lineWidth: 2, lineCap: .butt))
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
                  
                  if (crosswordModel.lastAccessed != nil) {
                      Text("Last accessed " + dateFormatter.string(from: crosswordModel.lastAccessed!))
                          .font(.caption)
                          .italic()
                          .foregroundColor(Color.emptyGray)
                  }
              }
          }
      }
      .contentShape(Rectangle())
      .onTapGesture {
          chosenCrossword = crosswordForRow
          showArchive = false
          shouldSendCrosswordData = true
      }
  }
}
