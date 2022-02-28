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
    @State var shouldSendGoBackToLobbyMessage = false
    @State var shouldSendCrosswordData = false
    var xWordViewModel: XWordViewModel = XWordViewModel(crossword: Crossword())

    var body: some View {
            VStack {
                Text("CrossWorld!").font(.largeTitle)
                NavigationLink(destination:
                    XWordView(
                        crossword: crossword,
                        crosswordBinding: $crossword,
                        xWordMatch: xWordMatch,
                        shouldSendGoBackToLobbyMessage: $shouldSendGoBackToLobbyMessage,
                        shouldSendCrosswordData: $shouldSendCrosswordData
                    ), isActive: $isShowingXWordView) {
                    Text(crossword.title).padding()
                }
                .disabled(crossword.title == "")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                        showDocumentPicker = true
                    }) {
                        Image(systemName: "folder")
                    }
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
                            Image(systemName: "person.crop.circle.badge.plus")
                        }
                        .disabled(crossword.title == "")
                    }
                }
            }
            .sheet(isPresented: self.$showDocumentPicker) {
                CrosswordDocumentPicker(crossword: $crossword/*, shouldSendCrosswordData: $shouldSendCrosswordData*/)
            }
            .onAppear(perform: {
                shouldSendGoBackToLobbyMessage = true
            })
            .onChange(of: crossword.title, perform: { _ in
                shouldSendCrosswordData = true
            })
            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight / 3, alignment: .center)
    }
}

struct LobbyView_Previews: PreviewProvider {
    static var previews: some View {
        LobbyView(xWordMatch: GKMatch())
    }
}
