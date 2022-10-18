//
//  ChangeDisplayNameView.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 10/16/22.
//

import SwiftUI

struct ChangeDisplayNameView: View {
    @State private var displayName: String = ""
    let userService = UserService()
    
    var body: some View {
        VStack {
            Text("Enter a display name:")
            TextField("", text: $displayName)
                .onSubmit {
                    userService.updateDisplayName(displayName: displayName)
                    print("new displayname: \(userService.getCurrentUserModel()?.displayName!)")
                }
        }
    }
}

struct ChangeDisplayNameView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeDisplayNameView()
    }
}
