//
//  CrosswordView.swift
//  word-o-crossv2
//
//  Created by Austin Kang on 11/23/21.
//

import SwiftUI

struct CrosswordView: View {
    @Binding var crossword: Crossword
    var body: some View {
        VStack {
            Text("Hello, CrossWorld!")
                .padding()
            Text(crossword.title)
        }
    }
}

struct CrosswordView_Previews: PreviewProvider {
    static var previews: some View {
        CrosswordView(crossword: .constant(Crossword()))
    }
}
