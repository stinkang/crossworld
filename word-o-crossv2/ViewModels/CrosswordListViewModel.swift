//
//  CrosswordListView.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 2/15/22.
//

import Foundation
import SwiftUI

class CrosswordListViewModel: ObservableObject {
    @Published var crosswordListItems: [CrosswordListItem] = []
    @Published var crosswords: [Crossword] = []

    func getCrossword(id: String, completion: @escaping (Crossword) -> Void) -> Bool {
        
        var crossword: Crossword = Crossword()
        let request = UrlBuilder.createRequest(method: "GET", route: "/board/" + id, body: nil)
        
        let session = URLSession.shared

        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                // Handle HTTP request error
                //self.errorMessage = error.localizedDescription
            } else if let data = data {
                // Handle HTTP request response
                do {
                    let jsonString = String(data: data, encoding: .utf8)!
                    print(jsonString)
                    crossword = try JSONDecoder().decode(Crossword.self, from: data)
                } catch DecodingError.dataCorrupted(let context) {
                    print(context)
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.valueNotFound(let value, let context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            } else {
                // Handle unexpected error
            }
            completion(crossword)
        }
        task.resume()

        return true
    }
    
    func getCrosswords(completion: @escaping ([Crossword]) -> Void) -> Bool {
        let request = UrlBuilder.createRequest(method: "GET", route: "/boards/", body: nil)
        
        let session = URLSession.shared
        var crosswords: [Crossword] = []

        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                // Handle HTTP request error
                //self.errorMessage = error.localizedDescription
            } else if let data = data {
                // Handle HTTP request response
                do {
                    let jsonString = String(data: data, encoding: .utf8)!
                    print(jsonString)
                    crosswords = try JSONDecoder().decode([Crossword].self, from: data)
                } catch DecodingError.dataCorrupted(let context) {
                    print(context)
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.valueNotFound(let value, let context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            } else {
                // Handle unexpected error
            }
            completion(crosswords)
        }
        task.resume()

        return true
    }
}
