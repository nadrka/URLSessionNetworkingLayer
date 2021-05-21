//
//  AlbumTarget.swift
//  NetworkingLayerTest
//
//  Created by Karol Nadratowski on 21/05/2021.
//

import Foundation

protocol PostsTarget: Target {}

extension PostsTarget {
    var base: String { "jsonplaceholder.typicode.com" }
}

