//
//  HomeRepository.swift
//  prashantHome
//
//  Created by Prashant Prajapati on 25/03/23.
//

import UIKit
import Alamofire

class HomeRepository: NSObject {
    var ws : BaseWebservice?
    init(token : String) {
        ws  = BaseWebservice(aToken: token)
    }
    
    func banner(result : @escaping (_ value: AdsBannerResponse?, _ error: Error?) -> Void)  {
        ws?.call(url: "home?marketCode=UZ", method: HTTPMethod.get , parameters: [], result: { (value, error) in
            if value != nil {
                do {
                    let json = try JSONSerialization.data(withJSONObject: value ?? [])
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let decodedData = try decoder.decode(AdsBannerResponse.self, from: json)
                    result(decodedData, nil)
                } catch {
                    result(nil, error)
                }
            } else {
                result(nil, error)
            }
        })
    }
    
    func products(parameters : [String : Any], result : @escaping (_ value: ProductResponse?, _ error: Error?) -> Void)  {
        print("productlist?page=\(parameters["page"] ?? 1)&productTagId=\(parameters["productTagId"] ?? 13)&marketCode=UZ")
        ws?.call(url: "productlist?page=\(parameters["page"] ?? 1)&productTagId=\(parameters["productTagId"] ?? 13)&marketCode=UZ", method: HTTPMethod.get , parameters: parameters, result: { (value, error) in
            if value != nil {
                do {
                    let json = try JSONSerialization.data(withJSONObject: value ?? [])
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let decodedData = try decoder.decode(ProductResponse.self, from: json)
                    result(decodedData, nil)
                } catch {
                    result(nil, error)
                }
            } else {
                result(nil, error)
            }
        })
    }
}
