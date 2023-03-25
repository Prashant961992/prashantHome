//
//  HomeViewModel.swift
//  prashantHome
//
//  Created by Prashant Prajapati on 25/03/23.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel : BaseViewModel {
    let model : HomeModel = HomeModel()
    var marketListData = [ProductMarketList]()
    
    func getBannerData(){
        self.isLoading.accept(true)
        
        let ws = HomeRepository(token:"")
        
        ws.banner { (response, error) in
            if response != nil {
                self.model.bannerData.accept(response ?? AdsBannerResponse())
                self.isSuccess.accept(true)
            } else if error != nil {
                self.isSuccess.accept(false)
                self.errorMsg.accept( error?.localizedDescription ?? "")
            }
            
            self.isLoading.accept(false)
            self.getProductData()
        }
    }
    
    func getProductData(){
        self.isLoading.accept(true)
        
        let ws = HomeRepository(token:"")
        var request = [String: Any]()
        
        request["page"] = (self.model.productData.value.data?.pagination?.page ?? 0) + 1
        request["productTagId"] = 13
        ws.products(parameters: request) { response, error in
            if response != nil {
                
                if let listData = response?.data?.marketList {
                    for (_, element) in listData.enumerated() {
                        self.marketListData.append(element)
                    }
                }
                self.model.productData.accept(response ?? ProductResponse())
                self.isSuccess.accept(true)
            } else if error != nil {
                self.isSuccess.accept(false)
                self.errorMsg.accept( error?.localizedDescription ?? "")
            }
            self.isLoading.accept(false)
        }
    }
    
}
