//
//  EnterCredentialsView.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 2/9/22.
//

import SwiftUI

struct EnterCredentialsView: View {
    @ObservedObject var userViewModel: UserViewModel
    
    var body: some View {
        Text(userViewModel.errorMessage)
            .foregroundColor(Color.red)
            .multilineTextAlignment(.center)
                                
        TextField("Email", text: $userViewModel.email)
            .frame(width: UIScreen.screenWidth)
        TextField("Username", text: $userViewModel.userName)
            .frame(width: UIScreen.screenWidth)
        ZStack(alignment: .trailing) {
            if userViewModel.hidePassword {
                SecureField("Password", text: $userViewModel.pw)
                    .frame(width: UIScreen.screenWidth)
            } else {
                TextField("Password", text: $userViewModel.pw)
                    .frame(width: UIScreen.screenWidth)
            }
            Button(action: {
                userViewModel.hidePassword.toggle()
            }) {
                Image(systemName: userViewModel.hidePassword ? "eye.slash" : "eye")
                    .accentColor(.gray)
            }
        }
    }
}

struct EnterCredentialsView_Previews: PreviewProvider {
    static var previews: some View {
        EnterCredentialsView(userViewModel: UserViewModel())
    }
}
