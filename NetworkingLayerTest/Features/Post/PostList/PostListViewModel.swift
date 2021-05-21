//
//  PostListViewModel.swift
//  NetworkingLayerTest
//
//  Created by Karol Nadratowski on 21/05/2021.
//

import Combine

class PostListViewModel: ObservableObject {
    private var disposebag = Set<AnyCancellable>()
    
    let postService = DefaultPostsService()
    @Published var posts = [
        Post(id: 1, userId: 1, title: "title", body: "Boyd asdasdsadas")
    ]
    
    init() {
        fetchPosts()
    }
    
    private func fetchPosts(params: GetPostsParams? = nil) {
        postService.fetchPosts(params: params)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] posts in
                    self?.posts = posts
                  })
            .store(in: &disposebag)
    }
    
    func fetchFilteredPosts() {
        let params = GetPostsParams(userId: 1)
        fetchPosts(params: params)
    }
    
    func createPost(with title: String, and body: String) {
        let post = PostCreation(userId: 1, title: title, body: body)
        postService.createPost(post)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error): print("creation error: \(error)")
                case .finished: break
                }
            },
            receiveValue: { [weak self] post in
                print("Post has been succesfully created!")
            })
            .store(in: &disposebag)
    }
}
