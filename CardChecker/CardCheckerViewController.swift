//
//  ViewController.swift
//  CardChecker
//
//  Created by Dominic Shahbazi on 26/08/2016.
//  Copyright © 2016 Dominic Shahbazi. All rights reserved.
//

import UIKit

class CardCheckerViewController: UIViewController {

    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var resultLabel: UILabel!
    
    var client: CardCheckerClient!
    var historyStore: HistoryStore!
    
    @IBAction func checkNumber(_ sender: UIButton) {
        
        activityIndicator.startAnimating()
        
        // pass a closure to the validateCardNumber, this will be called when number is retrieved.
        client.validateCardNumber(textField.text!) {
            (result: ValidateResult) -> Void in
            
            // Update the UI on the main thread rather then background thread
            DispatchQueue.main.async(execute: { () -> Void in
                
                switch result {
                    case let ValidateResult.success(cardResult):
                        if(cardResult.result) {
                            self.setResultLabel("Valid", color: UIColor.green)
                        } else {
                            self.setResultLabel("Invalid", color: UIColor.red)
                        }
                    
                        self.historyStore.addResult(cardResult)
                    
                    case ValidateResult.failure(_):
                        self.setResultLabel("Error!", color: UIColor.red)
                }
                self.resultLabel.isHidden = false
            })
        }
        activityIndicator.stopAnimating()
    }
    
    fileprivate func setResultLabel(_ text: String, color: UIColor) {
        self.resultLabel.text = text
        self.resultLabel.textColor = color
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CardCheckerViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Add rounded corners to button
        checkButton.layer.cornerRadius = 5;
        checkButton.layer.masksToBounds = true;
        
        checkButton.layer.borderWidth = 2.0
        checkButton.layer.borderColor = UIColor.white.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // if the triggered seque is the showiItem seque
        if segue.identifier == "ShowHistory" {
            let historyViewController = segue.destination as! HistoryViewController
            historyViewController.historyStore = historyStore
        }
    }
    
    override func viewDidLayoutSubviews() {
        // Underline the text field
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
        
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    
    }
    
}


