//
//  BaseWebservice.swift
//  prashantHome
//
//  Created by Prashant Prajapati on 25/03/23.
//

import Foundation


import UIKit
import Alamofire

class BaseWebservice: NSObject {
    
    
    let baseUrl = "http://qvr9g.mocklab.io/"
    var token = ""
    var headers : HTTPHeaders = [
        "Accept": "application/json"
    ]
    
    init(aToken : String) {
        token = aToken
        headers.update(name: "Authorization", value: "Bearer " + aToken)
    }
    
    func call(url : String, isdictionaryRequired : Bool = true , method : HTTPMethod, parameters :  Any, result : @escaping (_ value: Any?, _ error: NSError?) -> Void)  {
        
        let data : Data? = nil
        
        let finalURL = URL(string: baseUrl + url)!
       
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        
        request.httpBody = data
        
        let aRequest = AF.request(request)
        
        
        aRequest.responseData { response in
            switch response.result {
            case .success(let value):
                print(String(data: value, encoding: .utf8)!)
                result(self.convertToDictionary(text: String(data: value, encoding: .utf8)!), nil)
            case .failure(let error):
                print(error)
                let responseCode = error.responseCode ?? -1
                let errorTemp = NSError(domain: error.localizedDescription, code:responseCode, userInfo:nil)
                result(nil, errorTemp)
            }
        }
    }
    
    public func convertToDictionary(text: String) -> Any? {
        if let data = text.data(using: .utf8) {
            do {
                let pd = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                if pd == nil {
                    
                    let pa = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                    if pa == nil {
                        return text
                    }
                    return pa
                    
                }
                return pd
            } catch {
                
                print(error.localizedDescription)
                return text
            }
        }
        return nil
    }
}
