//
//  StartViewController.swift
//  Milliomaire
//
//  Created by Карим Руабхи on 14.05.2022.
//

import UIKit

class StartViewController: UIViewController {

    private let recordsCaretaker = RecordsCaretaker()
    
    @IBOutlet var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Game.shared.results = recordsCaretaker.receiveRecords()
        setCustomSpacing(stackView, space: 20)
    }
    
    private func setCustomSpacing(_ stack: UIStackView, space: CGFloat) {
        for itemIndex in 0..<stack.arrangedSubviews.count - 1 {
            stack.setCustomSpacing(space, after: stack.arrangedSubviews[itemIndex])
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    

}

