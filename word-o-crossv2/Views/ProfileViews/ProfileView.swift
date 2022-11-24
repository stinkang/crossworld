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
    
    var userService = UserService()
    var body: some View {
        VStack {
            Button(action: {
                userService.signOut()
                viewModel.userModel = nil
            }) {
                Text("Sign Out")
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: MakeXWordStartView(), isActive: $isShowingMakeXWordView) {
                    Image(systemName: "square.and.pencil")
                }
            }
        }
    }
}
//
//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
