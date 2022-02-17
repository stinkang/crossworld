//
//  UrlBuilder.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 2/14/22.
//

import Foundation

let baseUrl = "https://crossworld-beta.herokuapp.com"
let localBaseUrl = URL(string: "http://localhost:8080")!

struct UrlBuilder {

    static func createRequest(method: String, route: String, body: Data?) -> URLRequest {
        let url = URL(string: baseUrl + route)!
        var request = URLRequest(url: url)
        request.httpMethod = method
        if (body != nil) {
            request.httpBody = body
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return request
    }
}
