//
//  MovieDetailView.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 19.08.22.
//

import SwiftUI

struct MovieDetailView: View {
    @EnvironmentObject var store: ISDStore

    let movieID: String

    var body: some View {
        GeometryReader { proxy in
            VStack {
                if let movie = store.state.movieDetail.movie {
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
                    //.navigationTitle(movie.title)

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
                                    NavigationLink(value: Route.movieDetail(movie)) {
                                        HorizontalMovieCell(movie: movie)
                                            .frame(width: proxy.size.height / 6, height: proxy.size.height / 3)
                                            .clipShape(RoundedRectangle(cornerRadius: 4))
                                    }
                                }
                            }
                            .padding(.horizontal, 10)
                            .frame(height: proxy.size.height / 3)
                        }
                    } else {
                        Text("No similar movies available")
                    }
                } else if let error = store.state.movieDetail.error {
                    Button {
                        store.dispatch(.movieDetail(.clear))
                    } label: {
                        Text(error.localizedDescription)
                    }
                } else if store.state.movieDetail.isLoading {
                    HStack {
                        Spacer()

                        ProgressView("Loading...")

                        Spacer()
                    }
                } else {
                    Color.clear
                }
            }
        }
        .onAppear {
            store.dispatch(.movieDetail(.viewLoaded(self.movieID)))
        }
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(movieID: "tt13314558")
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
