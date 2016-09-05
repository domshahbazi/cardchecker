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
    
    @IBAction func clearHistory(sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "Clear All", style: .Destructive, handler: { (action) -> Void in
            self.historyStore.history.removeAll()
            self.tableView.reloadData()
        })
        
        alertController.addAction(deleteAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "History"
        tableView.rowHeight = 44
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setToolbarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(true, animated: animated)
    }
    
    // TODO - Implement table view controller methods
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyStore.history.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("HistoryCell") as! HistoryCell
        
        let historyItem = historyStore.history[indexPath.row]
        
        // configure cell with HistoryItem
        cell.numberLabel.text = historyItem.cardNumber
        cell.isValidLabel.text = historyItem.result ? "Valid" : "Invalid" // change color, make it red or green
        
        cell.isValidLabel.textColor = historyItem.result ? UIColor.greenColor() : UIColor.redColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
    func clearHistory() {
        // do somet
    }

}
