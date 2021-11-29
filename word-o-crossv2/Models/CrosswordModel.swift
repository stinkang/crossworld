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
    var target: String
    var valid: Bool
    var uniClue: Bool
    var admin: Bool
    var hasTitle: Bool
    var navigate: Bool
    var auto: Bool
    var rows: Int
    var cols: Int
    var grid: [String]
    var gridNums: [Int]
    var circles: [Int]?
    var acrossClues: [String]
    var downClues: [String]
    var acrossAnswers: [String]
    var downAnswers: [String]
    
    enum OuterKeys: String, CodingKey {
        case title, author, editor, copyright, publisher, date, dow,
            target, valid, admin, navigate, auto, size, grid, circles,
            clues, answers
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
        let cluesContnainer = try outerContainer.nestedContainer(keyedBy: CluesKeys.self, forKey: .clues)
        let answersContainer = try outerContainer.nestedContainer(keyedBy: AnswersKeys.self, forKey: .answers)
        
        self.title = try outerContainer.decode(String.self, forKey: .title)
        self.author = try outerContainer.decode(String.self, forKey: .author)
        self.editor = try outerContainer.decode(String.self, forKey: .editor)
        self.copyright = try outerContainer.decode(String.self, forKey: .copyright)
        self.publisher = try outerContainer.decode(String.self, forKey: .publisher)
        self.date = try outerContainer.decode(String.self, forKey: .date)
        self.dow = try outerContainer.decode(String.self, forKey: .dow)
        self.target = try outerContainer.decode(String.self, forKey: .target)
        self.valid = try outerContainer.decode(Bool.self, forKey: .valid)
        self.uniClue = try outerContainer.decode(Bool.self, forKey: .uniClue)
        self.admin = try outerContainer.decode(Bool.self, forKey: .admin)
        self.hasTitle = try outerContainer.decode(Bool.self, forKey: .hasTitle)
        self.navigate = try outerContainer.decode(Bool.self, forKey: .navigate)
        self.auto = try outerContainer.decode(Bool.self, forKey: .auto)
        self.rows = try sizeContainer.decode(Int.self, forKey: .rows)
        self.cols = try sizeContainer.decode(Int.self, forKey: .cols)
        self.grid = try outerContainer.decode([String].self, forKey: .grid)
        self.gridNums = try outerContainer.decode([Int].self, forKey: .gridNums)

        if let circles = try outerContainer.decodeIfPresent([Int].self, forKey: .circles) {
            self.circles = circles
        } else {
            self.circles = nil
        }

        self.acrossClues = try cluesContnainer.decode([String].self, forKey: .acrossClues)
        self.downClues = try cluesContnainer.decode([String].self, forKey: .downClues)
        self.acrossAnswers = try answersContainer.decode([String].self, forKey: .acrossAnswers)
        self.downAnswers = try answersContainer.decode([String].self, forKey: .downAnswers)
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
        self.rows = 4
        self.cols = 4
        self.grid = [""]
        self.gridNums = [0]
        self.circles = [0]
        self.acrossClues = [""]
        self.downClues = [""]
        self.acrossAnswers = [""]
        self.downAnswers = [""]
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
