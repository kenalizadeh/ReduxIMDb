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

    // A property wrapper type that can read and write a value owned by a source of truth.
    // Ref: https://developer.apple.com/documentation/swiftui/binding
    // -------------------------
    // @Binding lets us declare that one value actually comes from elsewhere, and should be shared in both places. This is not the same as @ObservedObject or @EnvironmentObject, both of which are designed for reference types to be shared across potentially many views.
    // Use the plain variable name to access the 'wrapped value' of the binding variable, which would be same as '_searchText.wrappedValue', which is String.
    // Use `$` prefixed variable name to access the 'projected value' of the binding variable, which would be same as '_searchText.projectedValue', which is Binding<String>.
    // ProjectedValues can depend on the implementation: For example: the projected value of the 'searchTextSubject' variable declared below is Binding<PassthroughSubject<String, Never>>, but in the case of Binding variables, it points to self.
    // Use the '_' prefixed variableName to access the variable itself, which is of type Binding<String>.
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
                        NavigationLink(value: Route.movieDetail(movie)) {
                            MovieCell(movie: movie)
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
