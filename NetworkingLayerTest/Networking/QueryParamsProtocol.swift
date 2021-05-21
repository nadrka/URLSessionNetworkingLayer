//
//  QueryParamsProtocol.swift
//  NetworkingLayerTest
//
//  Created by Karol Nadratowski on 21/05/2021.
//

import Foundation

public protocol QueryParamsProtocol {
    func prepareQueryItems() -> [URLQueryItem]
}

