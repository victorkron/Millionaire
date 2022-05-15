//
//  GameVC.swift
//  Millionaire
//
//  Created by Карим Руабхи on 14.05.2022.
//

import UIKit

class GameVC: UIViewController {
    private var questions: [Question] = [
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
    
    var sum = 10
    var currentQuestion = 0
    var delegate: GameSession?
    
    @IBOutlet var prize: UILabel!
    @IBOutlet var Button1: UIButton!
    @IBOutlet var Button2: UIButton!
    @IBOutlet var Button3: UIButton!
    @IBOutlet var Button4: UIButton!
    @IBOutlet var question: UILabel!
    @IBOutlet var endGameButton: UIBarButtonItem!
    @IBOutlet var helpButton: UIButton!
    
    @IBAction func didHelp(_ sender: UIButton) {
        questions[currentQuestion].removeTwoIncorrectAnswer()
        doSet(index: currentQuestion)
        Game.shared.gameSession?.didRemoveTwoIncorrectAnswer = true
        sender.isHidden = true
    }
    
    
    @IBAction func endGameBarButtonAction(_ sender: Any) {
        let record = Record(
            result: round(Double(delegate?.rightAnswers ?? 0) / Double(delegate?.questionCount ?? 0) * 100),
            date: Date()
        )
        var allRecords = Game.shared.results
        allRecords.append(record)
        Game.shared.addRecord(allResults: allRecords)
        Game.shared.gameSession = nil
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        if sender.currentTitle == questions[currentQuestion].rightAnswer {
            delegate?.addScore()
            changeQuestion()
        } else {
            endGame()
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        doSet(index: currentQuestion)
        let gameSession = GameSession(questionCount: questions.count)
        Game.shared.gameSession = gameSession
        delegate = Game.shared.gameSession // передаю в делегат текущий gameSession
    }
    
    func doSet(index: Int) {
        Button1.setTitle(questions[currentQuestion].answers[0], for: .normal)
        Button2.setTitle(questions[currentQuestion].answers[1], for: .normal)
        Button3.setTitle(questions[currentQuestion].answers[2], for: .normal)
        Button4.setTitle(questions[currentQuestion].answers[3], for: .normal)
        question.text = questions[currentQuestion].question
    }
    
    private func changeQuestion() {
        currentQuestion += 1
        if prize.text == "0$" {
            prize.text = "\(sum)$"
        } else {
            sum = sum*2
            prize.text = "\(sum)$"
        }
        
        if currentQuestion < questions.count {
            doSet(index: currentQuestion)
        } else {
            endGame()
        }
    }
    
    private func endGame() {
        endGameBarButtonAction(UIBarButtonItem())
    }
    

}
