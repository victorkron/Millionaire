//
//  SettingVC.swift
//  Millionaire
//
//  Created by Карим Руабхи on 19.05.2022.
//

import UIKit

class SettingVC: UIViewController {

    @IBOutlet var randomQuestionsSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        randomQuestionsSwitch.isOn = Game.shared.randomOrderOfQuestions
        randomQuestionsSwitch.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        Game.shared.randomOrderOfQuestions = randomQuestionsSwitch.isOn
    }

}
