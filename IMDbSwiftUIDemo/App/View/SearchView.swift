//
//  SearchView.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import SwiftUI
import Combine

struct SearchView: View {
    @EnvironmentObject var store: ISDStore

    // SwiftUI uses @State to allow you to modify values inside a struct, which would normally not be allowed because structs are value types.
    // SwiftUI’s @StateObject property wrapper is designed to fill a very specific gap in state management: when you need to create a reference type inside one of your views and make sure it stays alive for use in that view and others you share it with.
    @StateObject
    var viewModel: SearchViewModel = .init()

    @Binding
    var searchText: String

    var movies: Movies = []

    init(_ searchText: Binding<String>) {
        self._searchText = searchText
    }

    var body: some View {
        ScrollView {
            LazyVStack {
                if viewModel.isSearching {
                    HStack {
                        Spacer()

                        ProgressView("Searching...")

                        Spacer()
                    }
                }

                if case let .ready(movies) = store.state.search {
                    ForEach(movies) { movie in
                        NavigationLink(value: Route.movieDetail(movieID: movie.id)) {
                            HStack {
                                Text(movie.fullTitle)
                                    .foregroundColor(Color.black)

                                Spacer()

                                AsyncImage(url: URL(string: movie.imageURL.resized(.small))) { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 60)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                            .padding(10)
                            .frame(height: 60)
                        }
                    }
                }
            }
        }
        .onChange(of: searchText) { text in
            store.dispatch(.search(.search(text)))
            viewModel.searchText = text
        }
        .onReceive(
            viewModel
                .$searchText
                .debounce(for: 0.275, scheduler: DispatchQueue.main)
        ) { text in
            guard !text.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty else {
                store.dispatch(.search(.clearSearchResults))
                viewModel
                    .networkService
                    .cancel()

                return
            }

            viewModel
                .networkService
                .send()
        }
        .onReceive(viewModel.$movies) { movies in
            store.dispatch(.search(.searchResultsLoaded(movies)))
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(.constant("tenet"))
    }
}
