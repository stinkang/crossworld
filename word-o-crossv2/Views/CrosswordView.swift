//
//  CrosswordView.swift
//  word-o-crossv2
//
//  Created by Austin Kang on 11/23/21.
//

import SwiftUI

struct CrosswordView: View {
    var crossword: Crossword
    var body: some View {
        VStack {
            Text("Hello, CrossWorld!")
                .padding()
            Text(crossword.title)
        }
    }
}

struct CrosswordView_Previews: PreviewProvider {
    static var previews: some View {
        CrosswordView(crossword: loadJson(fileName: "Nov24th")!)
    }
}

func loadJson(fileName: String) -> Crossword? {
    if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)
            guard let crossword = try? JSONDecoder().decode(Crossword.self, from: data) else {
                fatalError("Can't decode crossword")
            }
            return crossword
        } catch {
            print("error:\(error)")
        }
    }
    return nil
}
