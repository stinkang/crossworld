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
                     
                Text("CrossWorld! is a collaborative, competitive app made for crossword enthusiasts by a (budding) crossword enthusiast.")

                Text("You can work on crosswords individually and try to place on the leaderboards, or team up with a friend and place on the leaderboards together!")
                
                Text("Get new crosswords to do by either uploading them yourself, having a friend send them to you, or pulling them straight from the leaderboards from the CrossWorld! community.")
                
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
                        Text("- Tap to the right of the clue to get to the next clue")
                        Text("- Tap to the left of the clue to get to the previous square (will be previous clue soon)")
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
