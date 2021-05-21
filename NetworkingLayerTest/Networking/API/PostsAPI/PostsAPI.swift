//
//  AlbumAPI.swift
//  NetworkingLayerTest
//
//  Created by Karol Nadratowski on 21/05/2021.
//

import Foundation

enum PostsAPI {
    case getPosts(params: GetPostsParams?)
    case getPost(id: Int)
    case createPost
}

extension PostsAPI: PostsTarget {
    var method: Method {
        switch self {
        case .getPosts,
             .getPost: return .get
        case .createPost: return .post
        }
    }
    
    var path: Path {
        switch self {
        case .getPosts,
             .createPost: return "/posts"
        case .getPost(let id): return "/posts/\(id)"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getPosts(let params): return params?.prepareQueryItems()
        default: return nil
        }
    }
}
