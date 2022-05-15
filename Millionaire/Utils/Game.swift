//
//  Game.swift
//  Millionaire
//
//  Created by Карим Руабхи on 14.05.2022.
//

import Foundation

class Game {
    static let shared = Game()
    private let recordsCaretaker = RecordsCaretaker()
    
    var results: [Record] = [] {
        didSet {
            recordsCaretaker.save(records: results)
        }
    }
    var gameSession: GameSession?
    
    private init() { }
    
    func addRecord(allResults: [Record]) {
        results = allResults
    }
    
    func clearRecords() {
        results = []
    }
    
    
}

struct Record: Codable {
    let result: Double
    let date: Date
}
