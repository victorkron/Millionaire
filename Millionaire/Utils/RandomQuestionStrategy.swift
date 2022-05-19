//
//  RandomQuestionStrategy.swift
//  Millionaire
//
//  Created by Карим Руабхи on 19.05.2022.
//

import Foundation

protocol SequenceQuestions {
    func getQuestions() -> [Question]
}

class RandomOrderQuestions: SequenceQuestions {
    func getQuestions() -> [Question] {
        return Game.shared.questions.shuffled()
    }
}

class DirectOrderQuestions: SequenceQuestions {
    func getQuestions() -> [Question] {
        return Game.shared.questions
    }
}
