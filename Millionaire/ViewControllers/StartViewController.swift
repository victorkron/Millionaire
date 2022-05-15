//
//  StartViewController.swift
//  Milliomaire
//
//  Created by Карим Руабхи on 14.05.2022.
//

import UIKit

class StartViewController: UIViewController {

    private let recordsCaretaker = RecordsCaretaker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Game.shared.results = recordsCaretaker.receiveRecords()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    

}

