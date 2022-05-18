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
    
    @IBOutlet var questionBlocksStack: UIStackView!
    @IBOutlet var secondButtonGroup: UIStackView!
    @IBOutlet var firstButtonGroup: UIStackView!
    
    @IBOutlet var helpButtonStack: UIStackView!
    
    
    @IBOutlet var question: UILabel!
    @IBOutlet var endGameButton: UIBarButtonItem!
    
    
    
    
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
    
    @IBAction func didPressedHelpButton(_ sender: CustomUIButton) {
        sender.layer.opacity = 0.2
        if (!sender.didTap) {
            switch sender.id {
            case 1:
                questions[currentQuestion].removeTwoIncorrectAnswer()
                doSet(index: currentQuestion)
                Game.shared.gameSession?.didRemoveTwoIncorrectAnswer = true
            case 2:
                print(2)
            case 3:
                print(3)
            default:
                print("default")
            }
        }
        
        sender.didTap = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        doSet(index: currentQuestion)
        let gameSession = GameSession(questionCount: questions.count)
        Game.shared.gameSession = gameSession
        delegate = Game.shared.gameSession // передаю в делегат текущий gameSession
        
        setCustomSpacing(firstButtonGroup, space: 10)
        setCustomSpacing(secondButtonGroup, space: 10)
        setCustomSpacing(questionBlocksStack, space: 10)
        setCustomSpacing(helpButtonStack, space: 5)
        
        for number in 0..<helpButtonStack.arrangedSubviews.count {
            (helpButtonStack.arrangedSubviews[number] as? CustomUIButton)?.id = number + 1
        }
    }
    
    private func setCustomSpacing(_ stack: UIStackView, space: CGFloat) {
        for itemIndex in 0..<stack.arrangedSubviews.count - 1 {
            stack.setCustomSpacing(space, after: stack.arrangedSubviews[itemIndex])
        }
    }
    
    func doSet(index: Int) {
        for number in 0..<questions[index].answers.count {
            let str = questions[index].answers[number]
            if number < questions[index].answers.count / 2 {
                (firstButtonGroup.arrangedSubviews[number] as? UIButton)?.setTitle(str, for: .normal)
            } else {
                let specialIndex = number - questions[index].answers.count / 2
                (secondButtonGroup.arrangedSubviews[specialIndex] as? UIButton)?.setTitle(str, for: .normal)
            }
        }
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
