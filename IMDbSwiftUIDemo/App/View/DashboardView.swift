//
//  DashboardView.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var store: ISDStore

    @ObservedObject
    var networkService: PopularMoviesNetworkService = .init()

    @State
    var searchText: String = ""

    var movies: Movies {
        Array(store.state.dashboard.movies.values.prefix(20))
    }

    var recentlyViewedMovies: Movies {
        store.state.dashboard.recentlyViewedMovies.reversed()
    }

    var body: some View {
        ScrollView {
            LazyVStack {
                Text("Recently Viewed")
                    .font(.title2)

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
                                    AsyncImage(url: URL(string: movie.resizedImageURL)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(height: 200)
                                    .padding(10)
                                }
                                .animation(Animation.easeIn(duration: 0.5), value: recentlyViewedMovies)
                                .simultaneousTapGesture {
                                    store.dispatch(.navigate(.movieDetail(movie)))
                                }
                            }
                        }
                    }
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search movies") {
            SearchView($searchText)
                .environmentObject(store)
        }
        .navigationTitle("IMDb")
        .toolbar {
            Button("Search") {
                store.dispatch(.navigate(.search("query")))
            }
        }
        .onAppear {
            if movies.isEmpty {
                networkService.fetch()
            }
        }
        .onReceive(networkService.$responseDTO, perform: { data in
            guard let data = data else { return }

            let movies = data.items.map(Movie.init(from:))
            store.dispatch(.mainScreen(.moviesLoaded(movies)))
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
