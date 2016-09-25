//
//  HistoryStore.swift
//  CardChecker
//
//  Created by Dom Shahbazi on 01/09/2016.
//  Copyright © 2016 Dominic Shahbazi. All rights reserved.
//

import UIKit

class HistoryStore {
    
    var history = [CardResult]()
    
    func addResult(_ result: CardResult) {
        history.append(result)
    }
    
}
