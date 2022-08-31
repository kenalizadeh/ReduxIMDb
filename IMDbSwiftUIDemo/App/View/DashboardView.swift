//
//  DashboardView.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var store: ISDStore

    // SwiftUI uses @State to allow you to modify values inside a struct, which would normally not be allowed because structs are value types.
    // A PassthroughSubject broadcasts elements to downstream subscribers and provides a convenient way to adapt existing imperative code to Combine. As the name suggests, this type of subject only passes through values meaning that it does not capture any state and will drop values if there aren’t any subscribers set.
    // A CurrentValueSubject wraps a single value and publishes a new element whenever the value changes. A new element is published even if the updated value equals the current value. Unlike the PassthroughSubject, a CurrentValueSubject always holds a value. A new subscriber will directly receive the current value contained in the subject.
    // Ref: https://www.avanderlee.com/combine/passthroughsubject-currentvaluesubject-explained/
    @State
    var searchText: String = ""

    var movies: Movies {
        Array(store.state.dashboard.movies.prefix(20))
    }

    var recentlyViewedMovies: Movies {
        store.state.dashboard.recentlyViewedMovies.reversed()
    }

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                LazyVStack {
                    HStack {
                        Text("Most Popular Movies")
                            .font(.largeTitle)

                        Spacer()
                    }.padding(.horizontal, 10)

                    ForEach(movies) { movie in
                        NavigationLink(value: Route.movieDetail(movie)) {
                            MovieCell(movie: movie)
                        }
                    }

                    if !recentlyViewedMovies.isEmpty {
                        Divider()
                            .padding(.top, 10)
                            .padding(.horizontal, 20)

                        HStack {
                            Text("Recently Viewed")
                                .font(.title2)

                            Spacer()
                        }.padding(.horizontal, 10)

                        ScrollView(.horizontal) {
                            LazyHStack {
                                ForEach(recentlyViewedMovies) { movie in
                                    NavigationLink(value: Route.movieDetail(movie)) {
                                        HorizontalMovieCell(movie: movie)
                                            .frame(width: proxy.size.height / 6, height: proxy.size.height / 3)
                                            .clipShape(RoundedRectangle(cornerRadius: 4))
                                    }
                                    .animation(Animation.easeIn(duration: 0.5), value: recentlyViewedMovies)
                                }
                            }
                            .padding(.horizontal, 10)
                            .frame(height: proxy.size.height / 3)
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search movies") {
                SearchView($searchText)
            }
            .navigationTitle("IMDb")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environmentObject(
                ISDStore(
                    initial: ISDAppState(),
                    reducer: rootReducer,
                    thunks: [
                        recentlyViewedMoviesThunk
                    ]
                )
            )
    }
}
