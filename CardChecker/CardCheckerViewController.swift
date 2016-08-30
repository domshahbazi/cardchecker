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
    
    var client: CardCheckerClient?
    
    @IBAction func checkNumber(sender: UIButton) {
        
        activityIndicator.startAnimating()
        
        // pass a closure to the validateCardNumber, this will be called when number is retrieved.
        client!.validateCardNumber(textField.text!) {
            (result: CardResult) -> Void in
            
            // Update the UI on the main thread rather then background thread
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                if(result.result) {
                    self.setResultLabel("Valid", color: UIColor.greenColor())
                } else {
                    self.setResultLabel("Invalid", color: UIColor.redColor())
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
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

