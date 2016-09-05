//
//  ViewController.swift
//  CardChecker
//
//  Created by Dominic Shahbazi on 26/08/2016.
//  Copyright © 2016 Dominic Shahbazi. All rights reserved.
//

import UIKit

class CardCheckerViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var resultLabel: UILabel!
    
    var client: CardCheckerClient!
    var historyStore: HistoryStore!
    
    @IBAction func checkNumber(sender: UIButton) {
        
        activityIndicator.startAnimating()
        
        // pass a closure to the validateCardNumber, this will be called when number is retrieved.
        client.validateCardNumber(textField.text!) {
            (result: ValidateResult) -> Void in
            
            // Update the UI on the main thread rather then background thread
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                switch result {
                    case let ValidateResult.Success(cardResult):
                        if(cardResult.result) {
                            self.setResultLabel("Valid", color: UIColor.greenColor())
                        } else {
                            self.setResultLabel("Invalid", color: UIColor.redColor())
                        }
                    
                        self.historyStore.addResult(cardResult)
                    
                    case ValidateResult.Failure(_):
                        self.setResultLabel("Error!", color: UIColor.redColor())
                }
                self.resultLabel.hidden = false
            })
        }
        activityIndicator.stopAnimating()
    }
    
    private func setResultLabel(text: String, color: UIColor) {
        self.resultLabel.text = text
        self.resultLabel.textColor = color
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CardCheckerViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // if the triggered seque is the showiItem seque
        if segue.identifier == "ShowHistory" {
            let historyViewController = segue.destinationViewController as! HistoryViewController
            historyViewController.historyStore = historyStore
        }
    }

}

