//
//  PublishXWordView.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 12/13/22.
//

import SwiftUI

struct PublishXWordView: View {
    @EnvironmentObject var makeXWordViewModel: MakeXWordViewModel
    @State var title = ""
    @Binding var publishXWordSheetShowing: Bool
    @State var anonymousOn: Bool = false
    let firebaseService = FirebaseService()
    var body: some View {
        let percentageComplete = makeXWordViewModel.getPercentageComplete()
        VStack {
            if percentageComplete != 100.00 {
                Spacer()
                Text("Your puzzle is " + String(format: "%.2f", percentageComplete) + "% complete.")
                Spacer()
            } else {
                Spacer()
                Text("Your puzzle is " + String(format: "%.2f", percentageComplete) + "% complete!")
                    .foregroundColor(.green)
                Spacer()
            }
            Text("Title:")
            TextField("Enter a title for your crossword", text: $makeXWordViewModel.title)
                .multilineTextAlignment(.center)
            Spacer()
            HStack {
                Spacer()
                Text("Publish anonymously")
                Toggle(isOn: $anonymousOn) {}
                    .onChange(of: anonymousOn) { value in
                        makeXWordViewModel.author = anonymousOn ? "Anonymous" : UserService().getCurrentUser()!.displayName!
                    }
                .toggleStyle(.switch)
                Spacer()
            }
            Spacer()
            Button(action: {
                let crossword = Crossword(makeCrosswordViewModel: makeXWordViewModel)
                firebaseService.uploadBlankCrosswordLeaderboard(crossword: crossword)
                publishXWordSheetShowing = false
            }) {
                Text("Publish Crossword")
                    .foregroundColor(.white)
                    .frame(width: 150, height: 40)
                    .background(percentageComplete == 100.00 ? .green : .emptyGray)
                    .cornerRadius(15)
                    .padding(.trailing, 10)
                    .padding(.bottom, 10)
            }
            .disabled(percentageComplete != 100.00)
        }
    }
}

//struct PublishXWordView_Previews: PreviewProvider {
//    static var previews: some View {
//        PublishXWordView()
//    }
//}
