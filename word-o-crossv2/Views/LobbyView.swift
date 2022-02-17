//
//  LobbyView.swift
//  word-o-crossv2
//
//  Created by Austin Kang on 11/23/21.
//

import SwiftUI

struct LobbyView: View {

    @State var crossword = Crossword()
    @State private var showDocumentPicker = false

    var body: some View {
        VStack {
            Text("CrossWorld!").font(.largeTitle)
            Button(action: {
                showDocumentPicker = true
            }) {
                Label("Import file", systemImage: "folder")
            }
            .padding()
            NavigationLink(destination: XWordView(crossword: crossword)) {
                Text(crossword.title).padding()
            }
            .disabled(crossword.title == "")
            NavigationLink(destination: CrosswordListView()) {
                Text("Crossword Archive").padding()
            }
        }
        .sheet(isPresented: self.$showDocumentPicker) {
            CrosswordDocumentPicker(crossword: $crossword)
        }
    }
}

struct LobbyView_Previews: PreviewProvider {
    static var previews: some View {
        LobbyView()
    }
}
