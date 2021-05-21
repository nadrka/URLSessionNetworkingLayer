//
//  AlbumService.swift
//  NetworkingLayerTest
//
//  Created by Karol Nadratowski on 21/05/2021.
//

import Combine

protocol PostsService {
    func fetchPosts(params: GetPostsParams?) -> ResponsePublisher<[Post]>
    func fetchPost(with id: Int) -> ResponsePublisher<Post>
    func createPost(_ post: PostCreation) -> ResponsePublisher<Post>
}

final class DefaultPostsService: PostsService {
    let client = Client()
    
    func fetchPosts(params: GetPostsParams? = nil) -> ResponsePublisher<[Post]> {
        let endpoint = PostsAPI.getPosts(params: params)
        return client.execute(target: endpoint, decodingType: [Post].self)
    }
    
    func fetchPost(with id: Int) -> ResponsePublisher<Post> {
        let endpoint = PostsAPI.getPost(id: id)
        return client.execute(target: endpoint, decodingType: Post.self)
    }
    
    func createPost(_ post: PostCreation) -> ResponsePublisher<Post> {
        let endpoint = PostsAPI.createPost
        return client.execute(target: endpoint, input: post, decodingType: Post.self)
    }
}
