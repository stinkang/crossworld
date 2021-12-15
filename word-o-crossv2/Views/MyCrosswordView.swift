//
//  CrosswordView.swift
//  word-o-crossv2
//
//  Created by Austin Kang on 11/23/21.
//

import SwiftUI

struct MyCrosswordView: View {
    @Binding var crossword: Crossword
    @FocusState private var focusedSquare: Int?
    //var squareCorrectness: [Bool]
    var body: some View {
        VStack(alignment: .leading) {
            Text(crossword.title)
            VStack(spacing: 0) {
                ForEach(0..<crossword.cols, id: \.self) { col in
                    HStack(spacing: 0) {
                        ForEach(0..<crossword.rows, id: \.self) { row in
                            CrosswordSquare(answerText: crossword.grid[col * crossword.rows + row], index: col * crossword.rows + row, crossword: crossword, givenText: "")
                        }
                    }
                }
            }
            Spacer()
        }
        .padding()
        .onAppear() {
            focusedSquare = 0
        }
    }
}

struct CrosswordSquare: View {
    let answerText: String
    let index: Int
    let crossword: Crossword
    @State var givenText: String
    var body: some View {
        TextField("", text: $givenText)
            .frame(maxWidth: 25, maxHeight: 25)
            .aspectRatio(1, contentMode: .fill)
            .border(Color.black)
            .background(answerText == "." ? Color.black : (answerText == givenText ? Color.green : Color.offWhite))
            .foregroundColor(Color.black)
            .multilineTextAlignment(.center)
            .disabled(answerText == ".")
    }
}

struct MyCrosswordView_Previews: PreviewProvider {
    static var previews: some View {
        MyCrosswordView(crossword: .constant(Crossword()))
    }
}
