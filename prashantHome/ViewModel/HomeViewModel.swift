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
        }
    }
    
}
