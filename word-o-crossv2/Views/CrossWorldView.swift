//
//  CrossWorldView.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 2/9/22.
//

import SwiftUI

struct CrossWorldView: View {
    @StateObject var userViewModel: UserViewModel = UserViewModel()

    var body: some View {
        ZStack {
            if (userViewModel.currentUserId == "") {
                CreateUserOrLoginView()
            } else {
                LobbyView()
                    .toolbar {
                        NavigationLink(destination: ProfileView().environmentObject(userViewModel)) {
                            Text("Logged in as " + userViewModel.currentUserName)
                        }
                    }
            }
        }
        .environmentObject(userViewModel)
    }
}

struct CrossWorldView_Previews: PreviewProvider {
    static var previews: some View {
        CrossWorldView()
    }
}
