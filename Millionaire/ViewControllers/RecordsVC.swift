//
//  RecordsVC.swift
//  Millionaire
//
//  Created by Карим Руабхи on 14.05.2022.
//

import UIKit

class RecordsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private let dateFormater: DateFormatter = {
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .short
        
        return dateFormater
    }()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Game.shared.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath)
        let record = Game.shared.results[indexPath.row]
        cell.textLabel?.text = self.dateFormater.string(from: record.date)
        cell.detailTextLabel?.text = "\(record.result)%"
        return cell
    }

}
