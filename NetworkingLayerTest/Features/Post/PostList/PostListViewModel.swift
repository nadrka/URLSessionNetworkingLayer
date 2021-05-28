//
//  PostListViewModel.swift
//  NetworkingLayerTest
//
//  Created by Karol Nadratowski on 21/05/2021.
//

import Combine

class ObservableViewModel: ObservableObject {
    var disposeBag = Set<AnyCancellable>()
}

final class PostListViewModel: ObservableViewModel {
    let postService = DefaultPostsService()
    @Published var posts = [Post]()
    
    override init() {
        super.init()
        
        fetchPosts()
    }
    
    private func fetchPosts(params: GetPostsParams? = nil) {
        postService.fetchPosts(params: params)
            .sinkResult { [weak self] result in
                switch result {
                case .success(let posts): self?.posts = posts
                case .failure(let error): print(error)
                }
            }
            .store(in: &disposeBag)
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
            receiveValue: { _ in
                print("Post has been succesfully created!")
            })
            .store(in: &disposeBag)
    }
}

extension Publisher {
    func sinkResult(completion: @escaping (Result<Output, Failure>) -> ()) -> AnyCancellable {
        return sink(
            receiveCompletion: { result in
                if case let .failure(error) = result {
                    completion(.failure(error))
                }
            },
            receiveValue: { output in
                completion(.success(output))
            }
        )
    }
}
