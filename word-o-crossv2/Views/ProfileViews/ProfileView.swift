//
//  ProfileView.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 10/14/22.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var viewModel: LobbyViewModel
    @State var isShowingMakeXWordView = false
    @State var isShowingMakeNewXWordView = false
    @State var isShowingSettingsView = false
    @State private var showDrafts = false
    @State var makeCrossword = MakeCrossword()
    
    var userService = UserService()
    var body: some View {
        VStack {

            Spacer()
            NavigationLink(destination:
                MakeXWordView(
                    makeCrossword: makeCrossword
                ), isActive: $isShowingMakeXWordView) {
                    Text("Continue Drafting Crossword")
                        .foregroundColor(.white)
                        .frame(width: 150, height: 40)
                        .background(makeCrossword.title == "" ? Color.gray : Color.green)
                        .cornerRadius(15)
                        .padding(.trailing, 10)
                        .padding(.bottom, 10)
            }
            //.disabled(makeCrossword.title == "")
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: MakeXWordStartView(), isActive: $isShowingMakeNewXWordView) {
                    HStack {
                        Text("New")
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showDrafts = true
                }) {
                    HStack {
                        Text("Drafts")
                        Image(systemName: "square.3.layers.3d.down.right")
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: ProfileSettingsView(viewModel: viewModel), isActive: $isShowingSettingsView) {
                    Image(systemName: "gearshape")
                }
            }
        }
        .sheet(isPresented: self.$showDrafts) {
            MakeCrosswordListView(
                makeCrossword: $makeCrossword,
                showArchive: $showDrafts
            )
        }
    }
}
//
//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
