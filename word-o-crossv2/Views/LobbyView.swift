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
    @State var gcButtonPressed: Bool = false
    @State var gcAuthenticated: Bool = false
    var xWordViewModel: XWordViewModel = XWordViewModel(crossword: Crossword())

    var body: some View {
            VStack {
                Text("CrossWorld!").font(.largeTitle)
                NavigationLink(destination: XWordView(crossword: crossword, xWordMatch: xWordMatch), isActive: $isShowingXWordView) {
                    Text(crossword.title).padding()
                }
                .foregroundColor(Color(UIColor.link))
                .disabled(crossword.title == "")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Import") {
                        showDocumentPicker = true
                    }
                    .foregroundColor(Color(UIColor.link))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    ZStack{
                        MenuView(
                            isShowingXWordView: $isShowingXWordView,
                            xWordMatch: $xWordMatch,
                            crossword: $crossword,
                            buttonPressed: $gcButtonPressed,
                            gcAuthenticated: $gcAuthenticated
                        )
                        Button(action: {
                            gcButtonPressed = true
                        }) {
                            Image(systemName: "person.2.fill")
                        }
                        .foregroundColor(crossword.title == "" ? Color(uiColor: .lightGray) : Color(uiColor: .link))
                        .disabled(crossword.title == "")
                    }
                }
            }
            .onChange(of: crossword.title) { _ in
                xWordViewModel.changeShouldSendCrossword(to: true)
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
