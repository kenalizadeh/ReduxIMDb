//
//  DashboardView.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var store: ISDStore

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
                                    NavigationLink(
                                        destination: {
                                            MovieDetailView(movieID: movie.id)
                                                .navigationTitle(movie.title)
                                        },
                                        label: {
                                            HorizontalMovieCell(movie: movie)
                                                .frame(width: proxy.size.height / 6, height: proxy.size.height / 3)
                                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                        }
                                    )
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
                    middlewares: [
                        recentlyViewedMoviesThunk
                    ]
                )
            )
    }
}
