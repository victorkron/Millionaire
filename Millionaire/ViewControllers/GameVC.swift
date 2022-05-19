//
//  GameVC.swift
//  Millionaire
//
//  Created by Карим Руабхи on 14.05.2022.
//

import UIKit

class GameVC: UIViewController {
    
    private var questionsSequence: SequenceQuestions =
    Game.shared.randomOrderOfQuestions ? RandomOrderQuestions() : DirectOrderQuestions()
    
    private var questions: [Question]?
    
    private var duration = 1.5
    private var width = 0
    private var height = 0
    private var currentShape = CAShapeLayer()
    
    var sum = Observable<Double>(0)
    var startSum: Double = 15625
    var currentQuestion = Observable<Int>(0)
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
        guard
            let questions = questions
        else { return }
        if currentQuestion.value < questions.count && sender.currentTitle == questions[currentQuestion.value].rightAnswer {
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
                questions?[currentQuestion.value].removeTwoIncorrectAnswer()
                doSet(index: currentQuestion.value)
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
        setObservers()
        
        questions = questionsSequence.getQuestions()
        doSet(index: currentQuestion.value)
        let gameSession = GameSession(questionCount: questions?.count ?? 0)
        Game.shared.gameSession = gameSession
        delegate = Game.shared.gameSession // передаю в делегат текущий gameSession
        
        setCustomSpacing(firstButtonGroup, space: 10)
        setCustomSpacing(secondButtonGroup, space: 10)
        setCustomSpacing(questionBlocksStack, space: 10)
        setCustomSpacing(helpButtonStack, space: 5)
        
        for number in 0..<helpButtonStack.arrangedSubviews.count {
            (helpButtonStack.arrangedSubviews[number] as? CustomUIButton)?.id = number + 1
        }
        questionNumberLabel.text = "\(currentQuestion.value)/\(questions?.count ?? 0)"
        setAnimation()
    }
    
    private func setObservers() {
        sum.addObserver(
            self,
            options: [.new]
        ) {
            [weak self] sum, _ in
            guard let self = self else { return }
            UIView.transition(
                with: self.prize,
                duration: self.duration,
                options: [
                    .transitionFlipFromBottom
                ]
            ) {
                self.prize.text = "\(self.sum.value)$"
                if self.sum.value == 0 {
                    self.sum.value = self.startSum
                }
            }
        }
        
        currentQuestion.addObserver(
            self,
            options: [.new]
        ) {
            [weak self] sum, _ in
            guard
                let self = self,
                let count = self.questions?.count
            else { return }
            Game.shared.gameSession?.percentRightAnswer = Double(self.currentQuestion.value) / Double(count)
            Game.shared.gameSession?.currentQuestion = self.currentQuestion.value
        }
    }
    
    private func setCustomSpacing(_ stack: UIStackView, space: CGFloat) {
        for itemIndex in 0..<stack.arrangedSubviews.count - 1 {
            stack.setCustomSpacing(space, after: stack.arrangedSubviews[itemIndex])
        }
    }
    
    func doSet(index: Int) {
        guard
            let questions = questions
        else { return }

        for number in 0..<questions[index].answers.count {
            let str = questions[index].answers[number]
            if number < questions[index].answers.count / 2 {
                (firstButtonGroup.arrangedSubviews[number] as? UIButton)?.setTitle(str, for: .normal)
            } else {
                let specialIndex = number - questions[index].answers.count / 2
                (secondButtonGroup.arrangedSubviews[specialIndex] as? UIButton)?.setTitle(str, for: .normal)
            }
        }
        question.text = "\(currentQuestion.value + 1). \(questions[currentQuestion.value].question)"
    }
    
    private func changeQuestion() {
        guard
            let questions = questions
        else { return }
        currentQuestion.value += 1
        self.sum.value = self.sum.value * 2
        
        if currentQuestion.value < questions.count {
            changeState(questionNumberLabel, newValue: "\(currentQuestion.value)/\(questions.count)")
            doSet(index: currentQuestion.value)
        } else {
            changeState(questionNumberLabel, newValue: "\(currentQuestion.value)/\(questions.count)")
        }
    }
    
    private func endGame() {
        endGameBarButtonAction(UIBarButtonItem())
    }
    

}

extension GameVC {
    func setAnimation() {
        guard
            let questions = questions
        else { return }
        let shape = CAShapeLayer()
        let path = configPath()
        
        shape.path = path.cgPath
        shape.lineWidth = 3
        shape.strokeColor = UIColor.purple.cgColor
        shape.fillColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.00, alpha: 0).cgColor
        shape.strokeStart = 0.0
        shape.strokeEnd = Double(currentQuestion.value + 1) / Double(questions.count)
        
        
        
        let strokeStartAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeStart))
        let strokeEndAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
        
        if currentQuestion.value == 0 {
            shape.strokeEnd = 0.0
            
            strokeStartAnimation.fromValue = -0.1
            strokeStartAnimation.toValue = 0.0
            
            strokeEndAnimation.fromValue = 0.0
            strokeEndAnimation.toValue = 0.0
        } else {
            shape.strokeEnd = Double(currentQuestion.value) / Double(questions.count)
            
            strokeStartAnimation.fromValue = Double(currentQuestion.value - 1) / Double(questions.count) - 0.1
            strokeStartAnimation.toValue = Double(currentQuestion.value) / Double(questions.count) - 0.1
            
            strokeEndAnimation.fromValue = Double(currentQuestion.value - 1) / Double(questions.count) - 0.1
            strokeEndAnimation.toValue = Double(currentQuestion.value) / Double(questions.count)
        }
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = duration
        animationGroup.repeatCount = 1 //.infinity
        animationGroup.animations = [
//            strokeStartAnimation,
            strokeEndAnimation
        ]
        
        
        shape.add(animationGroup, forKey: nil)
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
        guard
            let questions = questions
        else { return }
        setAnimation()
        UIView.transition(
            with: sender,
            duration: duration,
            options: [
                .transitionCrossDissolve
            ]
        ){
            sender.text = newValue
        } completion: { _ in
            if self.currentQuestion.value == questions.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + self.duration) {
                    self.endGame()
                }
            }
        }
    }
}
