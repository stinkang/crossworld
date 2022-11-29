//
//  ProfileSettingsView.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 11/28/22.
//

import SwiftUI

struct ProfileSettingsView: View {
    var userService = UserService()
    @ObservedObject var viewModel: LobbyViewModel
    var body: some View {
        VStack {
            Text("Settings")
            Spacer()
        }.toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    userService.signOut()
                    viewModel.userModel = nil
                }) {
                    Text("Sign Out")
                }
            }
        }
    }
}

//struct ProfileSettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileSettingsView()
//    }
//}
