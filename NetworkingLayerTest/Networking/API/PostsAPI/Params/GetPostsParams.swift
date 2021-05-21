//
//  GetPostsParams.swift
//  NetworkingLayerTest
//
//  Created by karollo on 21/05/2021.
//

import Foundation

struct GetPostsParams: QueryParamsProtocol {
    private let userId: Int?
    
    init(userId: Int?) {
        self.userId = userId
    }
    
    func prepareQueryItems() -> [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        
        if let userId = userId {
            queryItems.append(URLQueryItem(name: "userId", value: String(userId)))
        }
        
        return queryItems
    }
}
