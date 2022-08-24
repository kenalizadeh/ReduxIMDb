//
//  MovieDetailView.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 19.08.22.
//

import SwiftUI

struct MovieDetailView: View {
    @EnvironmentObject var store: ISDStore

    @StateObject
    var viewModel: MovieDetailViewModel

    let movieID: String

    init(movieID: String) {
        self.movieID = movieID
        self._viewModel = StateObject(wrappedValue: MovieDetailViewModel(movieID: movieID))
    }

    var body: some View {
        GeometryReader { proxy in
            VStack {
                if let movie = viewModel.movie {
                    VStack {
                        AsyncImage(url: URL(string: movie.image.resized(.large))) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: proxy.size.width)
                        .clipped()

                        HStack {
                            NavigationLink {
                                MovieReviewsView(movieID: movie.id)
                                    .environmentObject(store)
                            } label: {
                                Text("See Reviews")
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.blue)
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                                    .font(.footnote)
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                    .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
                    .navigationTitle(movie.title)
                    .onAppear {
                        store.dispatch(.movieDetail(.movieDetailLoaded(Movie(from: movie))))
                    }

                    if !movie.similarMovies.isEmpty {
                        Divider()
                            .padding(.top, 10)
                            .padding(.horizontal, 20)

                        HStack {
                            Text("Similar Movies")
                                .font(.title)

                            Spacer()
                        }
                        .padding(.horizontal, 10)

                        ScrollView(.horizontal) {
                            LazyHStack {
                                ForEach(movie.similarMovies) { movie in
                                    NavigationLink(value: Route.movieDetail(movieID: movie.id)) {
                                        HorizontalMovieCell(movie: movie)
                                            .frame(width: proxy.size.height / 6, height: proxy.size.height / 3)
                                            .clipShape(RoundedRectangle(cornerRadius: 4))
                                    }
                                }
                            }
                            .padding(.horizontal, 10)
                            .frame(height: proxy.size.height / 3)
                        }
                    }
                } else if viewModel.hasError {
                    Button {
                        viewModel
                            .networkService
                            .send()
                    } label: {
                        Text("Something went wrong. Please try again")
                    }

                } else {
                    ProgressView("Loading...")
                        .onAppear {
                            viewModel
                                .networkService
                                .send()
                        }
                }
            }
        }
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(movieID: "tt13314558")
            .environmentObject(
                ISDStore(
                    initial: ISDAppState(),
                    reducer: isdReducer,
                    middlewares: [
                        searchMiddleware
                    ],
                    thunks: [
                        recentlyViewedMoviesThunk
                    ]
                )
            )
    }
}
