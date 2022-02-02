//
//  CrosswordModel.swift
//  word-o-crossv2
//
//  Created by Austin Kang on 11/24/21.
//

import Foundation

struct Crossword: Decodable {
    var title: String
    var author: String
    var editor: String
    var copyright: String
    var publisher: String
    var date: String
    var dow: String
    var target: String?
    var valid: Bool?
    var uniClue: Bool?
    var admin: Bool
    var hasTitle: Bool?
    var navigate: Bool?
    var auto: Bool?
    var rows: Int
    var cols: Int
    var grid: [String]
    var gridNums: [Int]
    var circles: [Int]?
    var acrossClues: [String]
    var downClues: [String]
    var clueNamesToCluesMap: Dictionary<String, String> // was crossword.clues
    var tagsToCluesMap: Array<Dictionary<String, String>>
    var cluesToTagsMap: Dictionary<String, [Int]>
    var acrossAnswers: [String]
    var downAnswers: [String]
    var notes: String?
    var solved: Bool
    var entries: [String]
    
    enum OuterKeys: String, CodingKey {
        case title, author, editor, copyright, publisher, date, dow,
            target, valid, admin, navigate, auto, size, grid, circles,
            clues, answers, notes
        case uniClue = "uniclue"
        case hasTitle = "hastitle"
        case gridNums = "gridnums"
        case accrossMap = "acrossmap"
        case downMap = "downmap"
        case rBars = "rbars"
        case bbars = "bbars"
    }
    
    enum SizeKeys: String, CodingKey {
        case rows, cols
    }
    
    enum CluesKeys: String, CodingKey {
        case acrossClues = "across"
        case downClues = "down"
    }
    
    enum AnswersKeys: String, CodingKey {
        case acrossAnswers = "across"
        case downAnswers = "down"
    }

    init(from decoder: Decoder) throws {
        let outerContainer = try decoder.container(keyedBy: OuterKeys.self)
        let sizeContainer = try outerContainer.nestedContainer(keyedBy: SizeKeys.self, forKey: .size)
        let cluesContainer = try outerContainer.nestedContainer(keyedBy: CluesKeys.self, forKey: .clues)
        let answersContainer = try outerContainer.nestedContainer(keyedBy: AnswersKeys.self, forKey: .answers)
        
        self.title = try outerContainer.decode(String.self, forKey: .title)
        self.author = try outerContainer.decode(String.self, forKey: .author)
        self.editor = try outerContainer.decode(String.self, forKey: .editor)
        self.copyright = try outerContainer.decode(String.self, forKey: .copyright)
        self.publisher = try outerContainer.decode(String.self, forKey: .publisher)
        self.date = try outerContainer.decode(String.self, forKey: .date)
        self.dow = try outerContainer.decode(String.self, forKey: .dow)

        if let target = try outerContainer.decodeIfPresent(String.self, forKey: .target) {
            self.target = target
        } else {
            self.target = nil
        }

        if let valid = try outerContainer.decodeIfPresent(Bool.self, forKey: .valid) {
            self.valid = valid
        } else {
            self.valid = nil
        }

        if let uniClue = try outerContainer.decodeIfPresent(Bool.self, forKey: .uniClue) {
            self.uniClue = uniClue
        } else {
            self.uniClue = nil
        }

        self.admin = try outerContainer.decode(Bool.self, forKey: .admin)

        if let hasTitle = try outerContainer.decodeIfPresent(Bool.self, forKey: .hasTitle) {
            self.hasTitle = hasTitle
        } else {
            self.hasTitle = nil
        }

        if let navigate = try outerContainer.decodeIfPresent(Bool.self, forKey: .navigate) {
            self.navigate = navigate
        } else {
            self.navigate = nil
        }

        if let auto = try outerContainer.decodeIfPresent(Bool.self, forKey: .auto) {
            self.auto = auto
        } else {
            self.auto = nil
        }

        let rows = try sizeContainer.decode(Int.self, forKey: .rows)
        self.rows = rows
        
        let cols = try sizeContainer.decode(Int.self, forKey: .cols)
        self.cols = cols

        let grid = try outerContainer.decode([String].self, forKey: .grid)
        self.grid = grid

        let gridNums = try outerContainer.decode([Int].self, forKey: .gridNums)
        self.gridNums = gridNums

        if let circles = try outerContainer.decodeIfPresent([Int].self, forKey: .circles) {
            self.circles = circles
        } else {
            self.circles = nil
        }
        
        let acrossClues = try cluesContainer.decode([String].self, forKey: .acrossClues)
        let downClues = try cluesContainer.decode([String].self, forKey: .downClues)

        self.acrossClues = acrossClues
        self.downClues = downClues
        self.clueNamesToCluesMap = Crossword.buildClueNamesToCluesMap(gridNums: gridNums, acrossClues: acrossClues, downClues: downClues, cols: cols, grid: grid)

        let tagsToCluesMap = Crossword.buildTagsToCluesMap(gridNums: gridNums, cols: cols, grid: grid)
        self.tagsToCluesMap = tagsToCluesMap
        self.cluesToTagsMap = Crossword.buildCluesToTagsMap(tagsToCluesMap: tagsToCluesMap)
        
        self.acrossAnswers = try answersContainer.decode([String].self, forKey: .acrossAnswers)
        self.downAnswers = try answersContainer.decode([String].self, forKey: .downAnswers)
        
        if let notes = try outerContainer.decodeIfPresent(String.self, forKey: .notes) {
            self.notes = notes
        } else {
            self.notes = nil
        }
        self.solved = false

        var entries = Array(repeating: "", count: grid.count)
        for i in 0..<grid.count {
            if (grid[i] == ".") {
                entries[i] = "."
            }
        }
        self.entries = entries
    }
    
    // Naive
    static func squareShouldHaveAcrossClue(squareNumber: Int, cols: Int, grid: Array<String>) -> Bool {
        let isNotBlackSquare = grid[squareNumber] != "."
        let isEdgeSquare = squareNumber % cols == 0
        let hasBlackSquareToTheLeft = !isEdgeSquare && grid[squareNumber - 1] == "."
        let hasAtLeastTwoWhiteSquaresToTheRight =
            (squareNumber + 1) % cols != 0
            && (squareNumber + 2) % cols != 0
            && grid[squareNumber + 1] != "."
            && grid[squareNumber + 2] != "."

        return isNotBlackSquare && (isEdgeSquare || hasBlackSquareToTheLeft) && hasAtLeastTwoWhiteSquaresToTheRight
    }
    
    // Naive
    static func squareShouldHaveDownClue(squareNumber: Int, cols: Int, grid: Array<String>) -> Bool {
        let isNotBlackSquare = grid[squareNumber] != "."
        let isEdgeSquare = squareNumber < cols
        let hasBlackSquareAbove = squareNumber - cols >= 0 && grid[squareNumber - cols] == "."
        let hasAtLeastTwoWhiteSquaresBelow =
            squareNumber + cols < grid.count
            && squareNumber + cols * 2 < grid.count
            && grid[squareNumber + cols] != "."
            && grid[squareNumber + cols * 2] != "."
        
        return isNotBlackSquare && (isEdgeSquare || hasBlackSquareAbove) && hasAtLeastTwoWhiteSquaresBelow
    }
    
    static func getDownClueForSquare(squareNumber: Int, cols: Int, gridNums: Array<Int>, grid: Array<String>) -> String {
        var currentIndex = squareNumber
        while (currentIndex >= 0) {
            let squareClueNumber = gridNums[currentIndex]
            if squareClueNumber != 0 && squareShouldHaveDownClue(squareNumber: currentIndex, cols: cols, grid: grid) {
                return String(squareClueNumber) + "D"
            }
            currentIndex -= cols
        }
        return ""
    }
    
    static func getAcrossClueForSquare(squareNumber: Int, cols: Int, gridNums: Array<Int>, grid: Array<String>) -> String {
        var currentIndex = squareNumber
        while (currentIndex >= 0) {
            let squareClueNumber = gridNums[currentIndex]
            if squareClueNumber != 0 && squareShouldHaveAcrossClue(squareNumber: currentIndex, cols: cols, grid: grid) {
                return String(squareClueNumber) + "A"
            }
            currentIndex -= 1
        }
        return ""
    }

    static func buildClueNamesToCluesMap(gridNums: Array<Int>, acrossClues: Array<String>, downClues: Array<String>, cols: Int, grid: Array<String> ) -> Dictionary<String, String>
    {
        var map: Dictionary<String, String> = [:]
        var i = 0
        var downIndex = 0
        var acrossIndex = 0
        for gridNum in gridNums {
            if (gridNum != 0) {
                if (squareShouldHaveDownClue(squareNumber: i, cols: cols, grid: grid)) {
                    map[String(gridNum) + "D"] = downClues[downIndex]
                    downIndex += 1
                }
                if (squareShouldHaveAcrossClue(squareNumber: i, cols: cols, grid: grid)) {
                    map[String(gridNum) + "A"] = acrossClues[acrossIndex]
                    acrossIndex += 1
                }
            }
            i += 1
        }
        return map
    }
    
    static func buildTagsToCluesMap(gridNums: Array<Int>, cols: Int, grid: Array<String>) -> Array<Dictionary<String, String>> {
        var array: Array<Dictionary<String, String>> = []
        for i in 0..<gridNums.count {
            var map: Dictionary<String, String> = [:]
//            if (gridNum != 0) {
//                if (squareShouldHaveDownClue(squareNumber: i, cols: cols, grid: grid)) {
//                    map["D"] = String(gridNum) + "D"
//                } else {
//                    map["D"] = ""
//                }
//                if (squareShouldHaveAcrossClue(squareNumber: i, cols: cols, grid: grid)) {
//                    map["A"] = String(gridNum) + "A"
//                } else {
//                    map["A"] = ""
//                }
//            } else {
//                map["D"] = ""
//                map["A"] = ""
//            }
            map["A"] = getAcrossClueForSquare(squareNumber: i, cols: cols, gridNums: gridNums, grid: grid)
            map["D"] = getDownClueForSquare(squareNumber: i, cols: cols, gridNums: gridNums, grid: grid)
            array.append(map)
        }
        return array
    }
    
    static func buildCluesToTagsMap(tagsToCluesMap: Array<Dictionary<String, String>>)  -> Dictionary<String, [Int]> {
        var map: Dictionary<String, [Int]> = [:]
        for tag in 0..<tagsToCluesMap.count {
            for dir in ["A", "D"] {
                if (tagsToCluesMap[tag].count > 0 ) {
                    let clue = tagsToCluesMap[tag][dir]
                    if map[clue!] == nil {
                        map[clue!] = []
                    }
                    map[clue!]!.append(tag)
                }
            }
        }
        return map
    }

    init() {
        self.title = ""
        self.author = ""
        self.editor = ""
        self.copyright = ""
        self.publisher = ""
        self.date = ""
        self.dow = ""
        self.target = ""
        self.valid = true
        self.uniClue = true
        self.admin = true
        self.hasTitle = true
        self.navigate = true
        self.auto = true
        self.rows = 15
        self.cols = 15
        let grid = [""]
        self.grid = grid
        self.gridNums = [1]
        self.circles = [0]
        self.acrossClues = [""]
        self.downClues = [""]
        self.acrossAnswers = [""]
        self.downAnswers = [""]
        self.clueNamesToCluesMap = [:]
        self.tagsToCluesMap = [[:]]
        self.cluesToTagsMap = [:]
        self.notes = ""
        self.solved = false
        let entries = Array(repeating: "", count: grid.count)
        self.entries = entries
        self.tagsToCluesMap = [["A" : "1A", "D" : "1D"]]
        self.clueNamesToCluesMap = ["1A" : "Welcome to CrossWorld", "1D" : "Welcome to CrossWorld"]
        self.cluesToTagsMap = ["1A" : [0], "1D" : [0]]
    }
}

struct CrosswordSize: Decodable {
    var rows: Int
    var cols: Int
}

struct CrosswordClues: Decodable {
    var across: [String]
    var down: [String]
}

struct CrosswordAnswers: Decodable {
    var across: [String]
    var down: [String]
}
