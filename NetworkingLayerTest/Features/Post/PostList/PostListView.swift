//
//  PostListView.swift
//  NetworkingLayerTest
//
//  Created by karollo on 21/05/2021.
//

import SwiftUI

struct PostListView: View {
    @StateObject var viewModel = PostListViewModel()
    @State var showSheet = false
    @State var title = ""
    @State var bodyText = ""
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    viewModel.fetchFilteredPosts()
                }, label: {
                    Text("Filter posts")
                })
                Spacer()
                Button(action: {
                    showSheet = true
                }, label: {
                    Image(systemName: "plus")
                })
            }
            .padding()
            
            List(viewModel.posts, id: \.id) { post in
                VStack(alignment: .leading, spacing: 10) {
                    Text(post.title)
                        .font(.headline)
                    
                    Text(post.body)
                        .font(.body)
                        .lineLimit(3)
                }
                .padding(5)
            }
        }
        .sheet(isPresented: $showSheet, content: {
            Form {
                Section {
                    TextField("Title", text: $title)
                    TextField("Body", text: $bodyText)
                }
                
                Button(action: {
                    viewModel.createPost(with: title, and: bodyText)
                }, label: {
                    Text("Create post")
                })
            }
        })
    }
}

struct PostListView_Previews: PreviewProvider {
    static var previews: some View {
        PostListView()
    }
}
