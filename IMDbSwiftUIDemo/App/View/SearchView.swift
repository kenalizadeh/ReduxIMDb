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

    // TODO: - State vs ObservedObject explanation
    // SwiftUI use “@State” to allow you to modify values inside a struct, which would normally not be allowed because structs are value types.
    @StateObject
    var viewState: SearchViewState = .init()

    @Binding
    var searchText: String

    var movies: Movies = []

    init(_ searchText: Binding<String>) {
        self._searchText = searchText
    }

    var body: some View {
        if viewState.isSearching {
            ProgressView {
                Text("Searching...")
                    .font(.headline)
            }
        } else {
            ScrollView {
                LazyVStack {
                    Text("Search movies")

                    if case let .ready(movies) = store.state.search {
                        ForEach(movies) { movie in
                            NavigationLink(value: Route.movieDetail(movie)) {
                                HStack {
                                    Text(movie.fullTitle)
                                        .foregroundColor(Color.black)

                                    Spacer()

                                    AsyncImage(url: URL(string: movie.resizedImageURL)) { image in
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
                            .simultaneousTapGesture {
                                store.dispatch(.navigate(.movieDetail(movie)))
                            }
                        }
                    }
                }
            }
            .onReceive(viewState.networkService.$responseDTO, perform: { data in
                guard let data = data else { return }

                let movies = data.results.map(Movie.init(from:))
                store.dispatch(.mainScreen(.searchResultsLoaded(movies)))
            })
            .onChange(of: searchText) { text in
                viewState.searchText = text
            }
            .onReceive(
                viewState
                    .$searchText
                    .debounce(for: 1, scheduler: DispatchQueue.main)
            ) { text in
                guard !text.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty else {
                    store.dispatch(.mainScreen(.clearSearchResults))
                    viewState.networkService.cancellable?.cancel()
                    return
                }

                viewState.networkService.call(query: text)
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(.constant("tenet"))
    }
}
