//
//  CreateUserView.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 2/9/22.
//

import SwiftUI

struct CreateUserView: View {
    @Binding var currentUserId: Int
    @State var userName = ""
    @State var pw = ""
    @State var email = ""
    @State var errorMessage = ""
    @State var hidePassword = true
    
    func tryCreateUser() -> Void {
        if (email.isEmpty) {
            errorMessage = "Email is empty"
        } else if (userName.isEmpty) {
            errorMessage = "Username is empty"
        } else if (pw.isEmpty) {
            errorMessage = "Password is empty"
        }
        if (!userName.isValidUsername) {
            errorMessage = "Username must be alphanumeric"
        } else if (!pw.isValidPassword) {
            errorMessage = "Passwords must be a minimum of 8 characters "
                            + "with at least one letter and one number."
        } else if (!email.isValidEmail) {
            errorMessage = "Email is not valid"
        }
        else {
            // TODO: send this object to the backend
            let user = User(userName: userName, email: email, pw: pw)

            currentUserId = user.id
        }
    }

    var body: some View {
        VStack {
            Text(errorMessage)
                .foregroundColor(Color.red)
                .multilineTextAlignment(.center)
                                    
            TextField("Email", text: $email)
                .frame(width: UIScreen.screenWidth)
            TextField("Username", text: $userName)
                .frame(width: UIScreen.screenWidth)
            ZStack(alignment: .trailing) {
                if hidePassword {
                    SecureField("Password", text: $pw)
                        .frame(width: UIScreen.screenWidth)
                } else {
                    TextField("Password", text: $pw)
                        .frame(width: UIScreen.screenWidth)
                }
                Button(action: {
                    hidePassword.toggle()
                }) {
                    Image(systemName: hidePassword ? "eye.slash" : "eye")
                        .accentColor(.gray)
                }
            }
            Button(action: {
                tryCreateUser()
            }) {
                Text("Create User")
            }
        }
    }
}

struct CreateUserView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUserView(currentUserId: .constant(0))
    }
}
