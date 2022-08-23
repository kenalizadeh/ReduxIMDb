//
//  DashboardView.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var store: ISDStore

    @StateObject
    var viewModel: DashboardViewModel = .init()

    @State
    var searchText: String = ""

    var recentlyViewedMovies: Movies {
        store.state.dashboard.recentlyViewedMovies.reversed()
    }

    var body: some View {
        ScrollView {
            LazyVStack {
                HStack {
                    Text("Most Popular Movies")
                        .font(.largeTitle)

                    Spacer()
                }.padding(.horizontal, 10)

                ForEach(viewModel.movies.prefix(20)) { movie in
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
                                NavigationLink(value: Route.movieDetail(movieID: movie.id)) {
                                    AsyncImage(url: URL(string: movie.imageURL.resized(.medium))) { image in
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
        .onAppear {
            if viewModel.movies.isEmpty {
                viewModel
                    .networkService
                    .send()
            }
        }
        .onReceive(viewModel.$movies, perform: { movies in
            store.dispatch(.mainScreen(.moviesLoaded(movies)))
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
