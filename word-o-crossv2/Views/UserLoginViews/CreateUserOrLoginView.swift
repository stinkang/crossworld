//
//  CreateUserOrLoginView.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 2/9/22.
//

import SwiftUI

struct CreateUserOrLoginView: View {
    @EnvironmentObject var userViewModel: UserViewModel

    var body: some View {
        VStack {
            EnterCredentialsView(
                userViewModel: userViewModel
            )
            Button(action: {
                userViewModel.createUser()
            }) {
                Text("Create User")
            }
                .padding(.bottom, 20)
            Text("or")
                .padding(.bottom, 20)
            Button(action: {
                userViewModel.login()
            }) {
                Text("Login")
            }

        }
    }
}

struct CreateUserOrLoginView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUserOrLoginView()
    }
}
