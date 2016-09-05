//
//  CardCheckerClient.swift
//  CardChecker
//
//  Created by Dominic Shahbazi on 27/08/2016.
//  Copyright © 2016 Dominic Shahbazi. All rights reserved.
//
import Foundation

struct CardResult {
    var cardNumber: String
    var result: Bool
}

enum ValidateResult {
    case Success(CardResult)
    case Failure(ErrorType)
}

enum ClientError: ErrorType {
    case RequestError
    case InvalidJSONData
}

class CardCheckerClient {
    
    private let baseURLString = "http://192.168.1.119:5000/validate"
    
    let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()
    
    func validateCardNumber(cardNumber: String, completion: (result: ValidateResult) -> Void) {
        
        let url = buildURL(cardNumber)!
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            if let jsonData = data {
                let result = self.resultFromJSONData(jsonData)
                completion(result: result)
            }
            else if let requestError = error {
                completion(result: ValidateResult.Failure(requestError))
            }
        }
        task.resume()
    }
    
    // needs cleaning up massively
    private func resultFromJSONData(data: NSData) -> ValidateResult {
        
        do {
            let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            guard let dict = jsonObject as? [String: AnyObject],
                let number = dict["number"] as? String,
                let valid = dict["valid"] as? Bool
                else { return ValidateResult.Failure(ClientError.InvalidJSONData) }
            
            return ValidateResult.Success(CardResult(cardNumber: number, result: valid))
            
        } catch let error {
            return ValidateResult.Failure(error)
        }
    }
    
    private func buildURL(cardNumber: String) -> NSURL? {
        
        let components = NSURLComponents(string: baseURLString)!
        let item = NSURLQueryItem(name: "cardnumber", value: cardNumber)
        var queryItems = [NSURLQueryItem]()
        queryItems.append(item)
        components.queryItems = queryItems
        
        return components.URL!
    }
    
}
