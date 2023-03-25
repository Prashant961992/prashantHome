//
//  AdsBannerResponse.swift
//  prashantHome
//
//  Created by Prashant Prajapati on 25/03/23.
//

import Foundation

import RxSwift
import RxCocoa

class HomeModel : BaseViewModel {
    var bannerData : BehaviorRelay<AdsBannerResponse> = BehaviorRelay(value: AdsBannerResponse())
}

// MARK: - AdsBannerResponse
struct AdsBannerResponse: Codable {
    let errorCode, message: String?
    let data: DataClass?
    
    init() {
        self.errorCode = nil
        self.message = nil
        self.data = nil
    }
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case data = "Data"
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    let mainBanner, brandZoneBanner, promotionalBanner, promotionalBanner2: [BrandZoneBanner]?
    let recommended: Recommended?
}

// MARK: - BrandZoneBanner
struct BrandZoneBanner: Codable {
    let id: Int?
    let imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "imageUrl"
    }
}

// MARK: - Recommended
struct Recommended: Codable {
    let name: String?
    let productTagID: Int?
    
    enum CodingKeys: String, CodingKey {
        case name
        case productTagID = "productTagId"
    }
}
