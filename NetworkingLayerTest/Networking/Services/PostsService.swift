//
//  AlbumService.swift
//  NetworkingLayerTest
//
//  Created by Karol Nadratowski on 21/05/2021.
//

import Combine

protocol PostsService {
    func fetchPosts(params: GetPostsParams?) -> APIResultPublisher<[Post]>
    func fetchPost(with id: Int) -> APIResultPublisher<Post>
    func createPost(_ post: PostCreation) -> APIResultPublisher<Post>
}

final class DefaultPostsService: PostsService {
    let client = PostClient()
    
    func fetchPosts(params: GetPostsParams? = nil) -> APIResultPublisher<[Post]> {
        client.execute(target: .getPosts(params: params), decodingType: [Post].self)
    }
    
    func fetchPost(with id: Int) -> APIResultPublisher<Post> {
        client.execute(target: .getPost(id: id), decodingType: Post.self)
    }
    
    func createPost(_ post: PostCreation) -> APIResultPublisher<Post> {
        client.execute(target: .createPost, input: post, decodingType: Post.self)
    }
}
