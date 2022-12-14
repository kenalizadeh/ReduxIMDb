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
                        NavigationLink(
                            destination: {
                                MovieDetailView(movieID: movie.id)
                                    .navigationTitle(movie.title)
                            },
                            label: {
                                MovieCell(movie: movie)
                            }
                        )
                    }
                } else if store.state.search.isSearching && store.state.search.searchResults.isEmpty {
                    Text("No results")
                }
            }
        }
        .onChange(of: searchText) { text in
            searchTextSubject.send(text)
            store.dispatch(ISDAction.search(.queryUserInput(text)))
        }
        .onReceive(
            searchTextSubject
                .filter { !$0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty }
                .debounce(for: 0.275, scheduler: DispatchQueue.main)
        ) { text in
            store.dispatch(ISDAction.search(.search(text)))
        }
//        .onReceive(
//            searchTextSubject
//                .filter { $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty }
//        ) { text in
//            store.dispatch(ISDAction.search(.cancelSearch))
//        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(.constant("tenet"))
    }
}
