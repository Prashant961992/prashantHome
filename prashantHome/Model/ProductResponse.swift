//
//  ProductResponse.swift
//  prashantHome
//
//  Created by Prashant Prajapati on 25/03/23.
//

import Foundation


import Foundation

// MARK: - ProductResponse
struct ProductResponse: Codable {
    let errorCode, message: String?
    let data: ProductDataClass?

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
struct ProductDataClass: Codable {
    let marketList: [ProductMarketList]?
    let pagination: ProductPagination?

    enum CodingKeys: String, CodingKey {
        case marketList
        case pagination = "Pagination"
    }
}

// MARK: - MarketList
struct ProductMarketList: Codable {
    let productID: Int?
    let name: String?
    let localPrice: Int?
    let imgURL: String?
    let rank: Int?
    let ratingEmoji: String?
    let localCrossedPrice: Int?
    let brand: String?

    enum CodingKeys: String, CodingKey {
        case productID = "productId"
        case name, localPrice
        case imgURL = "imgUrl"
        case rank, ratingEmoji, localCrossedPrice, brand
    }
}

// MARK: - Pagination
struct ProductPagination: Codable {
    let page, rowsPerPage, totalCount, totalPage: Int?
}
