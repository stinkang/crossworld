//
//  CrossWorldView.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 2/9/22.
//

import SwiftUI

struct CrossWorldView: View {
    @State var currentUserId: Int = 0

    var body: some View {
        ZStack {
            if (currentUserId == 0) {
                CreateUserView(currentUserId: $currentUserId)
            } else {
                LobbyView()
            }
        }
    }
}

struct CrossWorldView_Previews: PreviewProvider {
    static var previews: some View {
        CrossWorldView()
    }
}
