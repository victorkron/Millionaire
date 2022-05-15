//
//  Question.swift
//  Millionaire
//
//  Created by Карим Руабхи on 14.05.2022.
//

import Foundation

struct Question {
    var answers: [String]
    var rightAnswer: String
    var question: String
    
    func getAnswers() -> [String] {
        return answers
    }
    
    func getRightAnswer() -> String {
       return rightAnswer
    }
    
    func getQuestion() -> String {
       return question
    }
    
    
    
    mutating func removeTwoIncorrectAnswer() {
        guard
            let bool = Game.shared.gameSession?.didRemoveTwoIncorrectAnswer
        else { return }
        
        if bool {
            
        } else {
            var count = 0
            answers.forEach { (i) in
                if i != rightAnswer && count < answers.count / 2 {
                    guard
                        let index = answers.firstIndex(of: i)
                    else { return }
                    answers[index] = ""
                    count += 1
                }
            }
        }
    }
}
