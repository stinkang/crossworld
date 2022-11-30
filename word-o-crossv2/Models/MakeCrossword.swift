//
//  MakeCrossword.swift
//  word-o-crossv2
//
//  Created by Austin Kang on 11/24/21.
//

import Foundation

struct MakeCrossword: Codable {
    var title: String
    var author: String
    var date: Date
    var cols: Int
    var grid: [String]
    var notes: String
    var lastAccessed: Date
    var indexToAcrossCluesMap: Dictionary<Int, String>
    var indexToDownCluesMap: Dictionary<Int, String>
    var percentageComplete: Float
    var crosswordId: String?
    
    enum OuterKeys: String, CodingKey {
        case title, author, date, notes, cols, grid, crosswordId, lastAccessed, percentageComplete
    }
    
    init(from decoder: Decoder) throws {
        let outerContainer = try decoder.container(keyedBy: OuterKeys.self)
        
        self.title = try outerContainer.decode(String.self, forKey: .title)
        self.author = try outerContainer.decode(String.self, forKey: .author)
        self.date = try outerContainer.decode(Date.self, forKey: .date)
        self.cols = try outerContainer.decode(Int.self, forKey: .cols)
        self.grid = try outerContainer.decode([String].self, forKey: .grid)
        self.notes = try outerContainer.decode(String.self, forKey: .notes)
        self.lastAccessed = try outerContainer.decode(Date.self, forKey: .lastAccessed)
        self.indexToDownCluesMap = try outerContainer.decode(Dictionary<Int, String>.self, forKey: .lastAccessed)
        self.indexToAcrossCluesMap = try outerContainer.decode(Dictionary<Int, String>.self, forKey: .lastAccessed)
        self.percentageComplete = try outerContainer.decode(Float.self, forKey: .percentageComplete)
    }
    
    init(makeCrosswordModel: MakeCrosswordModel) {
        self.title = makeCrosswordModel.title!
        self.author = makeCrosswordModel.author!
        self.notes = makeCrosswordModel.notes!
        self.grid = makeCrosswordModel.grid!
        self.cols = Int(makeCrosswordModel.cols)
        self.date = makeCrosswordModel.date!
        self.lastAccessed = makeCrosswordModel.lastAccessed!
        self.indexToDownCluesMap = makeCrosswordModel.indexToDownCluesMap!
        self.indexToAcrossCluesMap = makeCrosswordModel.indexToAcrossCluesMap!
        self.percentageComplete = makeCrosswordModel.percentageComplete
    }

    init(title: String="Untitled", author: String="", date: Date=Date(), cols: Int=5, grid: [String]=[String](repeating: "", count: 25), notes: String="") {
        self.title = title
        self.author = author
        self.date = date
        self.cols = cols
        self.grid = grid
        self.notes = notes
        self.lastAccessed = Date()
        self.indexToAcrossCluesMap = Dictionary<Int, String>()
        self.indexToDownCluesMap = Dictionary<Int, String>()
        self.percentageComplete = 0.0
    }
}

extension MakeCrossword {
    func encode() -> Data? {
        return try? JSONEncoder().encode(self)
    }
    
    func encodeBackIntoJson() -> [String: Any]? {
        let encodedCrossword = try? JSONEncoder().encode(self)
        var dict: [String: Any]? = nil
        do {
            dict = try JSONSerialization.jsonObject(with: encodedCrossword!, options: []) as? [String : Any]
            dict!["entries"] = nil
            dict!["tagsToCluesMap"] = nil
            dict!["cluesToTagsMap"] = nil
            dict!["clueNamesToCluesMap"] = nil
            dict!["secondsElapsed"] = nil
        } catch {
            print("DEBUG: Could not serialize crossword")
        }
        return dict
    }
    
    static func decode(data: Data) -> Crossword? {
        //return try? JSONDecoder().decode(Crossword.self, from: data)
        var decodedData: Crossword? = nil
            do {
               // process data
                decodedData = try JSONDecoder().decode(Crossword.self, from: data)
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
        return decodedData
    }
}
