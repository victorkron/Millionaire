//
//  AddNewQuestionsVC.swift
//  Millionaire
//
//  Created by Карим Руабхи on 20.05.2022.
//

import UIKit

class AddNewQuestionsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var sectionCount = 1
    private var rowsInSection = 1

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AddQuestionCell", bundle: nil), forCellReuseIdentifier: "AddQuestionCell")
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func addQuestion(_ sender: Any) {
        guard
            let questions: [AddQuestionCell] = tableView.visibleCells as? [AddQuestionCell]
        else { return }
        questions.forEach { i in
            i.setQuestion()
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionCount
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddQuestionCell") as? AddQuestionCell
        else { return UITableViewCell() }
        
        cell.config()
        
        return cell
    }
    

}
