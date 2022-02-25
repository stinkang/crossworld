//
//  LobbyView.swift
//  word-o-crossv2
//
//  Created by Austin Kang on 11/23/21.
//

import SwiftUI
import GameKit

struct LobbyView: View {

    @State var crossword = Crossword()
    @State private var showDocumentPicker = false
    @State var isShowingXWordView = false
    @State var xWordMatch: GKMatch = GKMatch()

    var body: some View {
        VStack {
            Text("CrossWorld!").font(.largeTitle)
            Button(action: {
                showDocumentPicker = true
            }) {
                Label("Import file", systemImage: "folder")
            }
            .padding()
            NavigationLink(destination: XWordView(crossword: crossword, xWordMatch: xWordMatch), isActive: $isShowingXWordView) {
                Text(crossword.title).padding()
            }
            .disabled(crossword.title == "")
            MenuView(isShowingXWordView: $isShowingXWordView, xWordMatch: $xWordMatch, crossword: $crossword)
                .disabled(crossword.title == "")
        }
        .sheet(isPresented: self.$showDocumentPicker) {
            CrosswordDocumentPicker(crossword: $crossword)
        }
    }
}

struct LobbyView_Previews: PreviewProvider {
    static var previews: some View {
        LobbyView(xWordMatch: GKMatch())
    }
}
