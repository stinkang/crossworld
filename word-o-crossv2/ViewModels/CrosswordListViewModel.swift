//
//  CrosswordListView.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 2/15/22.
//

import Foundation
import SwiftUI

class CrosswordListViewModel: ObservableObject {
    @Published var crosswords: [CrosswordListItem] = []
    
    func getCrossword(completion: @escaping (Crossword)->()) -> Crossword {
        
        var crossword: Crossword = Crossword()
        let request = UrlBuilder.createRequest(method: "GET", route: "/board/372d955e-d2a2-4b5e-9014-8d21e21adb7e", body: nil)
        
        let session = URLSession.shared

        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                // Handle HTTP request error
                //self.errorMessage = error.localizedDescription
            } else if let data = data {
                // Handle HTTP request response
                do {
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
        }
        task.resume()

        return crossword
    }
    
    func getCrosswords(completion: @escaping ([String]) -> Void) -> Bool {
        let request = UrlBuilder.createRequest(method: "GET", route: "/boards/", body: nil)
        
        let session = URLSession.shared
        var crosswordIds: [String] = []

        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                // Handle HTTP request error
                //self.errorMessage = error.localizedDescription
            } else if let data = data {
                // Handle HTTP request response
                do {
                    let jsonString = String(data: data, encoding: .utf8)!
                    print(jsonString)
                    crosswordIds = try JSONDecoder().decode([String].self, from: data)
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
            completion(crosswordIds)
        }
        task.resume()

        return true
    }
}
