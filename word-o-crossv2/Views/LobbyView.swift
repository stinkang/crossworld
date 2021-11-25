//
//  LobbyView.swift
//  word-o-crossv2
//
//  Created by Austin Kang on 11/23/21.
//

import SwiftUI

struct LobbyView: View {

    @State private var fileURL = URL(string: "/")!
    @State private var showDocumentPicker = false

    var body: some View {
        VStack {
            Text(fileURL.absoluteString).padding()

            Button("Import file") {
                showDocumentPicker = true
            }
        }
        .sheet(isPresented: self.$showDocumentPicker) {
            DocumentPicker(fileURL: $fileURL)
        }
    }
}

struct LobbyView_Previews: PreviewProvider {
    static var previews: some View {
        LobbyView()
    }
}
