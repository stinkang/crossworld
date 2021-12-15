//
//  CrosswordModelTest.swift
//  word-o-crossv2Tests
//
//  Created by Austin Kang on 12/6/21.
//
//

import XCTest
@testable import word_o_crossv2

class CrosswordModelTests: XCTestCase {
    
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

import Foundation

let gridNums = [1,2,3,4,0,5,6,7,8,9,10,0,11,12,13,14,0,0,0,0,15,0,0,0,0,0,0,16,0,0,17,0,0,0,18,0,0,0,0,0,0,0,19,0,0,20,0,0,0,0,0,0,21,0,0,0,22,0,0,0,23,0,0,0,0,24,25,0,0,0,26,0,0,0,0,0,0,0,27,0,0,0,0,0,28,0,0,0,0,0,29,30,31,0,0,32,0,33,34,0,35,0,0,0,36,37,0,0,38,39,0,0,0,0,40,0,0,0,0,0,41,0,0,0,0,0,42,0,0,0,0,0,43,0,0,0,44,0,0,0,45,0,0,46,0,47,48,0,0,0,49,0,0,0,0,0,50,51,0,0,0,0,52,53,54,55,0,0,0,0,56,0,0,0,0,57,0,0,0,0,58,0,0,0,59,0,0,0,60,61,0,0,0,0,0,62,0,0,0,63,0,0,0,0,0,0,64,0,0,0,65,0,0,0,66,0,0,0,0,0,0,67,0,0,0]
let grid = ["S","L","A","G",".","O","B","T","U","S","E",".","S","S","E","H","A","I","R",".","N","E","W","L","O","W",".","U","P","N","O","M","N","I","P","O","T","E","N","C","E",".","P","O","E","O","A","T","E","S",".",".","R","A","O",".","D","E","R","M","P","R","I","V","A","T","E","P","R","O","P","E","R","T","Y",".",".",".","E","T","A","L",".",".","L","O","B","E","S",".","A","C","K",".",".","L","I","E","S",".","R","U","G","B","Y","T","R","A","S","H","C","O","M","P","A","C","T","O","R","S","M","A","L","T","A",".","T","O","I","L",".",".","S","A","L",".","Z","E","A","L","S",".",".","R","U","M","S",".",".",".","F","I","S","H","F","O","R","C","O","M","P","LIME","N","T","S","A","N","A","L",".","D","O","H",".",".","E","B","O","A","T","T","E","L",".","P","I","C","O","D","E","G","A","L","L","O","A","S","A",".","S","U","C","K","E","R",".","L","I","E","U","L","S","D",".","A","M","O","E","B","A",".","L","E","S","T"]

