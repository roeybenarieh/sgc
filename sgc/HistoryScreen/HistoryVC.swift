//
//  HistoryVCViewController.swift
//  sgc
//
//  Created by roey ben arieh on 07/08/2022.
//

import UIKit


class HistoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: variables
    var historyArr :[(date: Date, message: String)] = []
    
    //MARK: IBOutlet
    @IBOutlet weak var history: UITableView!
    
    //MARK: functions
    override func viewDidLoad() {
        super.viewDidLoad()

        history.delegate = self
        history.dataSource = self
        
        //adding listeners
        NotificationCenter.default.addObserver(self, selector: #selector(injectionConfirmed(notification:)), name: NSNotification.Name.init(rawValue: "InjectionConfirmation"), object: nil)
    }
    
    //MARK: listeners
    @objc func injectionConfirmed(notification:NSNotification){
        historyArr.insert((date: Date(), message: "Completed injection succesfuly"), at: 0)
        while historyArr.count > 100 {
            historyArr.removeLast()
        }
        history.reloadData()
    }
    
    //MARK: tableView functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let templateCell = tableView.dequeueReusableCell(withIdentifier: "injectionCell", for: indexPath)
                //templateCell.textLabel?.textColor = UIColor.systemGreen
        let record = historyArr[indexPath.row]
        templateCell.textLabel?.text = DateFormatter().string(from: record.date) + ":" + record.message
        
        return templateCell
    }

}
