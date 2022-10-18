//
//  ProfileView.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 10/14/22.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: LobbyViewModel
    var userService = UserService()
    var body: some View {
        Button(action: {
            userService.signOut()
            viewModel.userModel = nil
        }) {
            Text("Sign Out")
        }
    }
}
//
//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
