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

    @Binding
    var searchText: String

    // SwiftUI uses @State to allow you to modify values inside a struct, which would normally not be allowed because structs are value types.
    // SwiftUI’s @StateObject property wrapper is designed to fill a very specific gap in state management: when you need to create a reference type inside one of your views and make sure it stays alive for use in that view and others you share it with.
    @State
    var searchTextSubject: PassthroughSubject<String, Never> = .init()

    var cancellable: AnyCancellable?

    var movies: Movies = []

    init(_ searchText: Binding<String>) {
        self._searchText = searchText
    }

    var body: some View {
        ScrollView {
            LazyVStack {
                if store.state.search.isSearching {
                    HStack {
                        Spacer()

                        ProgressView("Searching...")

                        Spacer()
                    }
                }

                if let movies = store.state.search.searchResults {
                    ForEach(movies) { movie in
                        NavigationLink(value: Route.movieDetail(movie.id)) {
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
                } else if store.state.search.isSearching && store.state.search.searchResults.isEmpty {
                    Text("No results")
                }
            }
        }
        .onChange(of: searchText) { text in
            searchTextSubject.send(text)
            store.dispatch(.search(.queryUserInput(text)))
        }
        .onReceive(
            searchTextSubject
                .filter { !$0.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty }
                .debounce(for: 0.275, scheduler: DispatchQueue.main)
        ) { text in
            store.dispatch(.search(.search(text)))
        }
        .onReceive(
            searchTextSubject
                .filter { $0.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty }
        ) { text in
            store.dispatch(.search(.cancelSearch))
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(.constant("tenet"))
    }
}
