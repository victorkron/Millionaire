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
    
    private var duration = 2.0
    private var width = 0
    private var height = 0
    private var currentShape = CAShapeLayer()
    
    var sum = 15625
    var currentQuestion = 0
    var delegate: GameSession?
    
    @IBOutlet var prize: UILabel!
    
    @IBOutlet var questionNumberLabel: CustomUILabel!
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
        if currentQuestion < questions.count && sender.currentTitle == questions[currentQuestion].rightAnswer {
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
        questionNumberLabel.text = "\(currentQuestion)/\(questions.count)"
        setAnimation()
//        changeState(questionNumberLabel, newValue: "\(currentQuestion + 1)/\(questions.count)")
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
        UIView.transition(
            with: prize,
            duration: self.duration,
            options: [
                .transitionFlipFromLeft
            ]
        ) {
            if self.prize.text == "0$" {
                self.prize.text = "\(self.sum)$"
            } else {
                self.sum = self.sum*2
                self.prize.text = "\(self.sum)$"
            }
        } completion: { _ in
            
        }

        
        if currentQuestion < questions.count {
            changeState(questionNumberLabel, newValue: "\(currentQuestion)/\(questions.count)")
            doSet(index: currentQuestion)
        } else {
            changeState(questionNumberLabel, newValue: "\(currentQuestion)/\(questions.count)")
//            endGame()
        }
    }
    
    private func endGame() {
        endGameBarButtonAction(UIBarButtonItem())
    }
    

}

extension GameVC {
    
    
    func setAnimation() {
        let shape = CAShapeLayer()
        let path = configPath()
        
        shape.path = path.cgPath
        shape.lineWidth = 3
        shape.strokeColor = UIColor.purple.cgColor
        shape.fillColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.00, alpha: 0).cgColor
        shape.strokeStart = 0.0
        shape.strokeEnd = Double(currentQuestion + 1) / Double(questions.count)
        
        
        
        let strokeStartAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeStart))
        let strokeEndAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
        
        
        
        
        
        if currentQuestion == 0 {
            shape.strokeEnd = 0.0
            
            strokeStartAnimation.fromValue = -0.1
            strokeStartAnimation.toValue = 0.0
            
            strokeEndAnimation.fromValue = 0.0
            strokeEndAnimation.toValue = 0.0
        } else {
            shape.strokeEnd = Double(currentQuestion) / Double(questions.count)
            
            strokeStartAnimation.fromValue = Double(currentQuestion - 1) / Double(questions.count) - 0.1
            strokeStartAnimation.toValue = Double(currentQuestion) / Double(questions.count) - 0.1
            
            strokeEndAnimation.fromValue = Double(currentQuestion - 1) / Double(questions.count) - 0.1
            strokeEndAnimation.toValue = Double(currentQuestion) / Double(questions.count)
        }
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = duration
        animationGroup.repeatCount = 1 //.infinity
        animationGroup.animations = [
//            strokeStartAnimation,
            strokeEndAnimation
        ]
        
        
        shape.add(animationGroup, forKey: nil)
//        currentShape.removeFromSuperlayer()
        currentShape = shape
        
        questionNumberLabel.layer.addSublayer(currentShape)
    }
    
    func configPath() -> UIBezierPath {
        let cloudPath = UIBezierPath()
        let widthOffset = 10
        let startK = 0.4
        let differenceK = 0.3
        
        cloudPath.move(to: CGPoint(
            x: Int(questionNumberLabel.bounds.width * 0.5) - widthOffset,
            y: Int(questionNumberLabel.bounds.height * (0.5 - startK))
        ))
        
        cloudPath.addCurve(
            to: CGPoint(
                x: Int(questionNumberLabel.bounds.width * (0.5 + startK)) - widthOffset,
                y: Int(questionNumberLabel.bounds.height * 0.5)
            ),
            controlPoint1: CGPoint(
                x: Int(questionNumberLabel.bounds.width * (0.5 + differenceK)) - widthOffset,
                y: Int(questionNumberLabel.bounds.height * (0.5 - startK))
            ),
            controlPoint2: CGPoint(
                x: Int(questionNumberLabel.bounds.width * (0.5 + startK)) - widthOffset,
                y: Int(questionNumberLabel.bounds.height * (0.5 - differenceK))
            )
        )
        cloudPath.addCurve(
            to: CGPoint(
                x: Int(questionNumberLabel.bounds.width * 0.5) - widthOffset,
                y: Int(questionNumberLabel.bounds.height * (0.5 + startK))
            ),
            controlPoint1: CGPoint(
                x: Int(questionNumberLabel.bounds.width * (0.5 + startK)) - widthOffset,
                y: Int(questionNumberLabel.bounds.height * (0.5 + differenceK))
            ),
            controlPoint2: CGPoint(
                x: Int(questionNumberLabel.bounds.width * (0.5 + differenceK)) - widthOffset,
                y: Int(questionNumberLabel.bounds.height * (0.5 + startK))
            )
        )
        cloudPath.addCurve(
            to: CGPoint(
                x: Int(questionNumberLabel.bounds.width * (0.5 - startK)) - widthOffset,
                y: Int(questionNumberLabel.bounds.height * 0.5)
            ),
            controlPoint1: CGPoint(
                x: Int(questionNumberLabel.bounds.width * (0.5 - differenceK)) - widthOffset,
                y: Int(questionNumberLabel.bounds.height * (0.5 + startK))
            ),
            controlPoint2: CGPoint(
                x: Int(questionNumberLabel.bounds.width * (0.5 - startK)) - widthOffset,
                y: Int(questionNumberLabel.bounds.height * (0.5 + differenceK))
            )
        )
        
        cloudPath.addCurve(
            to: CGPoint(
                x: Int(questionNumberLabel.bounds.width * 0.5) - widthOffset,
                y: Int(questionNumberLabel.bounds.height * (0.5 - startK))
            ),
            controlPoint1: CGPoint(
                x: Int(questionNumberLabel.bounds.width * (0.5 - startK)) - widthOffset,
                y: Int(questionNumberLabel.bounds.height * (0.5 - differenceK))
            ),
            controlPoint2: CGPoint(
                x: Int(questionNumberLabel.bounds.width * (0.5 - differenceK)) - widthOffset,
                y: Int(questionNumberLabel.bounds.height * (0.5 - startK))
            )
        )
    
        cloudPath.move(to: CGPoint(
            x: Int(questionNumberLabel.bounds.width * 0.5) - widthOffset,
            y: Int(questionNumberLabel.bounds.height * (0.5 - startK))
        ))
        
        cloudPath.close()
        return cloudPath
    }
    
    func changeState(_ sender: UILabel, newValue: String) {
        UIView.transition(
            with: sender,
            duration: duration,
            options: [
                .transitionFlipFromBottom
            ]
        ){
            sender.text = newValue
        } completion: { _ in
            if self.currentQuestion == self.questions.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + self.duration / 2) {
                    self.endGame()
                }
                
            }
        }
        setAnimation()
    }
}
