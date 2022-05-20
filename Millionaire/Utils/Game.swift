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
    var randomOrderOfQuestions: Bool = false
    var questions: [Question] = [
        Question(
            answers: ["Фиолетовый", "Синий", "Зеленый", "Красный"],
            rightAnswer: "Зеленый",
            question: "Какого цвета Ёлка?"
        ),
        Question(
            answers: ["3", "7", "9", "5"],
            rightAnswer: "7",
            question: "Сколько цветов у радуги?"
        ),
        Question(
            answers: ["A", "B", "C", "D"],
            rightAnswer: "C",
            question: "Какой из витаминов преобладает в лимоне?"
        ),
        Question(
            answers: ["1963", "1961", "1965", "1964"],
            rightAnswer: "1961",
            question: "В каком году Юрий Гагарин полетел в космос?"
        ),
        Question(
            answers: ["Ургант", "Фейнман", "Эйнштейн", "Перельман"],
            rightAnswer: "Перельман",
            question: "Кто доказал гипотезу Пуанкаре?"
        ),
        Question(
            answers: ["Эйлера", "Гильберта", "Лапласа", "Фурье"],
            rightAnswer: "Фурье",
            question: "Какое преобразование используют для спектрального разложения сигнала во времени?"
        ),
        Question(
            answers: ["Юнг", "Гегель", "Ницше", "Шопенгауэр"],
            rightAnswer: "Ницше",
            question: "Кто из этих философов в 1864 году написал музыку на стихи А.С. Пушкина «Заклинание» и «Зимний вечер»?"
        )
    ]
    
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
