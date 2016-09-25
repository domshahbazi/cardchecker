//
//  HistoryViewController.swift
//  CardChecker
//
//  Created by Dom Shahbazi on 01/09/2016.
//  Copyright © 2016 Dominic Shahbazi. All rights reserved.
//

import UIKit

class HistoryViewController: UITableViewController {
    
    var historyStore: HistoryStore!
    
    @IBOutlet var clearButton: UIBarButtonItem!
    
    @IBAction func clearHistory(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "Clear All", style: .destructive, handler: { (action) -> Void in
            self.historyStore.history.removeAll()
            self.tableView.reloadData()
            self.configureClearHistoryButton()
        })
        
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "History"
        tableView.rowHeight = 44
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setToolbarHidden(false, animated: animated)
        
        configureClearHistoryButton()
    }
    
    fileprivate func configureClearHistoryButton() {
        clearButton.isEnabled = !(clearButton.isEnabled && historyStore.history.isEmpty)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(true, animated: animated)
    }
    
    // TODO - Implement table view controller methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyStore.history.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryCell
        
        let historyItem = historyStore.history[(indexPath as NSIndexPath).row]
        
        // configure cell with HistoryItem
        cell.numberLabel.text = historyItem.cardNumber
        cell.isValidLabel.text = historyItem.result ? "Valid" : "Invalid" // change color, make it red or green
        
        cell.isValidLabel.textColor = historyItem.result ? UIColor.green : UIColor.red
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }

}
