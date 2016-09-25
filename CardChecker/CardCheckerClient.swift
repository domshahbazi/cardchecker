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
    case success(CardResult)
    case failure(Error)
}

enum ClientError: Error {
    case requestError
    case invalidJSONData
}

class CardCheckerClient {
    
    fileprivate let baseURLString = "http://192.168.1.119:5000/validate"
    
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func validateCardNumber(_ cardNumber: String, completion: @escaping (_ result: ValidateResult) -> Void) {
        
        let url = buildURL(cardNumber)!
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            
            if let jsonData = data {
                let result = self.resultFromJSONData(jsonData)
                completion(result)
            }
            else if let requestError = error {
                completion(ValidateResult.failure(requestError))
            }
        }) 
        task.resume()
    }
    
    // needs cleaning up massively
    fileprivate func resultFromJSONData(_ data: Data) -> ValidateResult {
        
        do {
            let jsonObject: Any = try JSONSerialization.jsonObject(with: data, options: [])
            guard let dict = jsonObject as? [String: Any],
                let number = dict["number"] as? String,
                let valid = dict["valid"] as? Bool
                else { return ValidateResult.failure(ClientError.invalidJSONData) }
            
            return ValidateResult.success(CardResult(cardNumber: number, result: valid))
            
        } catch let error {
            return ValidateResult.failure(error)
        }
    }
    
    fileprivate func buildURL(_ cardNumber: String) -> URL? {
        
        var components = URLComponents(string: baseURLString)!
        let item = URLQueryItem(name: "cardnumber", value: cardNumber)
        var queryItems = [URLQueryItem]()
        queryItems.append(item)
        components.queryItems = queryItems
        
        return components.url!
    }
    
}
