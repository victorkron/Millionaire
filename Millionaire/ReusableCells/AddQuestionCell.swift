//
//  AddQuestionCell.swift
//  Millionaire
//
//  Created by Карим Руабхи on 20.05.2022.
//

import UIKit

class AddQuestionCell: UITableViewCell {

    var question = ""
    var rightAnswer = ""
    var answers: [String]? = ["", "", "", ""]
    private let questionsCaretaker = QuestionsCaretaker()
    
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBAction func didChangeSegmentValue(_ sender: UISegmentedControl) {
        rightAnswer = answers?[sender.selectedSegmentIndex] ?? ""
    }
    
    @IBOutlet var questionTextField: UITextField!
    
    @IBOutlet var textField1: CustomUITextField!
    @IBOutlet var textField2: CustomUITextField!
    @IBOutlet var textField3: CustomUITextField!
    @IBOutlet var textField4: CustomUITextField!
    
    func setQuestion() {
        guard
            let answers = answers
        else { return }
        if question != "" && rightAnswer != "" && answers != ["","","",""] {
            let newQuestion = Question(
                answers: answers,
                rightAnswer: rightAnswer,
                question: question
            )
            Game.shared.questions.append(newQuestion)
            var arr = questionsCaretaker.receiveQuestions()
            arr.append(newQuestion)
            questionsCaretaker.save(questions: arr)
        }
        textField1.text = ""
        textField2.text = ""
        textField3.text = ""
        textField4.text = ""
        questionTextField.text = ""
    }
    
    @objc func changeAnswerText(sender: CustomUITextField) {
        answers?[sender.id - 1] = sender.text ?? ""
    }
    
    @objc func didSetQuestion(sender: UITextField) {
        question = sender.text ?? ""
    }
    
    func config() {
        textField1.id = 1
        textField2.id = 2
        textField3.id = 3
        textField4.id = 4
        
        questionTextField.addTarget(self, action: #selector(didSetQuestion(sender:)), for: .allEvents)
        textField1.addTarget(self, action: #selector(changeAnswerText(sender:)), for: .allEvents)
        textField2.addTarget(self, action: #selector(changeAnswerText(sender:)), for: .allEvents)
        textField3.addTarget(self, action: #selector(changeAnswerText(sender:)), for: .allEvents)
        textField4.addTarget(self, action: #selector(changeAnswerText(sender:)), for: .allEvents)
    }
}
