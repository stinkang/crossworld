//
//  CrossWorldView.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 2/9/22.
//

import SwiftUI
import GameKit
import Firebase

struct CrossWorldView: View {
    @State var loginTapped = false
    @StateObject var viewModel = LobbyViewModel()
    let userService = UserService()
    
    var body: some View {
        ZStack {
            if (viewModel.userModel == nil) {
                VStack {
                    Spacer()
                    Image(uiImage: UIImage(named: "crossworld-logo") ?? UIImage())
                    Spacer()
                    NewLoginView()
                        .frame(width:UIScreen.screenWidth, height: 50, alignment: .center)
                        .navigationBarHidden(true)
                }
            } else {
                if (viewModel.userModel!.displayName! == "") {
                    ChangeDisplayNameView()
                }
                LobbyView()
            }
        }
        .onAppear(perform: {
            if let user = Auth.auth().currentUser {
                print("You're signed in as \(user.uid), email: \(user.email ?? "unknown")")
                viewModel.userModel = userService.getCurrentUserModel()
                
                print("displayName:")
                print(viewModel.userModel!.displayName!)
            }
        })
        .environmentObject(viewModel)
    }
}

struct CrossWorldView_Previews: PreviewProvider {
    static var previews: some View {
        CrossWorldView()
    }
}
