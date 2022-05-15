//
//  GameSession.swift
//  Millionaire
//
//  Created by Карим Руабхи on 14.05.2022.
//

import Foundation

class GameSession {
    
    var questionCount: Int
    var rightAnswers: Int = 0
    var didRemoveTwoIncorrectAnswer: Bool = false
    
    
    init(questionCount: Int) {
        self.questionCount = questionCount
    }
    
    func addScore() {
        rightAnswers += 1
    }
    
}
