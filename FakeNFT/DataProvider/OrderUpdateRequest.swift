//
//  ProfileUpdateRequest.swift
//  FakeNFT
//
//  Created by Almira Khafizova on 25.01.24.
//

import Foundation

struct OrderUpdateRequest: NetworkRequest {
    
    let order: OrderModel
    
    var endpoint: URL? {
        var urlComponents = URLComponents(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
        var components: [URLQueryItem] = []
        
        if let nfts = order.nfts {
            for nft in nfts {
                components.append(URLQueryItem(name: "nfts", value: nft))
            }
        }

        urlComponents?.queryItems = components
        return urlComponents?.url
    }
    var httpMethod: HttpMethod {
        return .put
    }
    
    var isUrlEncoded: Bool {
        return true
    }
    
    var dto: Encodable?
}
