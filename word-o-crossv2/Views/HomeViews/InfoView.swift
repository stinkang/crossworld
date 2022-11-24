//
//  InfoView.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 3/28/22.
//

import SwiftUI

struct InfoView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Welcome to CrossWorld!")
                    .font(.title)
                     
                Text("CrossWorld! is an app made for crossword enthusiasts by a crossword enthusiast.")
                
                Text("Get new crosswords to do by either uploading them yourself or pulling them straight from the leaderboards from the CrossWorld! community.")
                
                Group {
                    Text("Uploading Crosswords")
                        .font(.title2)

                    Text("The top left file button on the main page lets you import your own crosswords. Your crossword needs to be in .json format and adhere to the standard .json crossword format (most do -- see here: https://www.xwordinfo.com/JSON/). I got a whole archive of the past NYT crosswords from here: https://github.com/doshea/nyt_crosswords.")

                    Text("To add this folder to your phone:")
                    Group {
                        Text("- Go to the link on a Mac")
                        Text("- Click the green \"Code\" button")
                        Text("- Click \"Download ZIP\"")
                        Text("- Unzip the download in Finder")
                        Text("- Either drag the unzipped folder to your iCloud drive OR AirDrop the folder to your iPhone (and then save it to your Files app on your phone)")
                    }
                    .padding(.leading, 10)
                    Text("Saving this folder in your iCloud drive or Files is highly recommended for the best CrossWorld! experience.")
        
                    Text("Once you select a file, the button on the main page will turn green and take you to the crossword to solve.")
                }
                
                Group {
                    Text("Crossword Navigation")
                        .font(.title2)
                    Group {
                        Text("- Tap on the board to navigate to a square")
                        Text("- Tap on the clue or on the current square to change orientation")
                        Text("- Tap the ") + Text(Image(systemName: "chevron.forward.2")) + Text("/") + Text(Image(systemName: "chevron.backward.2")) + Text(" button to go to the next/previous clue")
                        Text("- Tap the ") + Text(Image(systemName: "chevron.forward")) + Text("/") + Text(Image(systemName: "chevron.backward")) + Text(" button to go to the next/previous square (if you're currently looking at DOWN clues these buttons will be ") + Text(Image(systemName: "chevron.up")) + Text("/") + Text(Image(systemName: "chevron.down")) + Text(")!")
                        Text("- Tap the ") + Text(Image(systemName: "pencil")).foregroundColor(.red) + Text(" button to overwrite squares in current word (otherwise filled-in squares will be skipped by default).")
                        Text("- Type \"😥\" to reveal the incorrect squares")
                    }
                    .padding(.leading, 10)
                    
                }
                
                Group {
                    Text("Stored Crosswords")
                        .font(.title2)
                    Text("If you've started any crossword, regardless of where you obtained it, it will be stored on your device and accessible through the ") + Text(Image(systemName: "square.3.layers.3d.down.right")).foregroundColor(.blue) + Text(" button on the main page. When you tap the button, you will see a list of all past crosswords and states of progress, ordered by date last accessed.")
                }
                Group {
                    Text("Collaborative/Competitive Crosswords:")
                        .font(.title2)
                    Text("Coming soon")
                }
            }
            .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
