//
//  word_o_crossv2Tests.swift
//  word-o-crossv2Tests
//
//  Created by Austin Kang on 11/23/21.
//

import XCTest
@testable import word_o_crossv2

class word_o_crossv2Tests: XCTestCase {
    
    var crosswordDocumentPicker: CrosswordDocumentPicker!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        self.crosswordDocumentPicker = CrosswordDocumentPicker(crossword: .constant(Crossword()))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCrosswordDocumentPickerDecodesAllCrosswords() throws {
        if let urls = Bundle.main.urls(forResourcesWithExtension: "json", subdirectory: "nyt_crosswords-master") {
            urls.forEach { url in
                self.crosswordDocumentPicker.makeCoordinator().decodeCrossword(url: url)
            }
            // TODO: Make the urls actually the list of all URLs in nyt_crosswords-master tinstead of just Nov24th.json
        }
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
