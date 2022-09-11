//
//  MovieReviewsView.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 21.08.22.
//

import SwiftUI

struct MovieReviewsView: View {
    @EnvironmentObject var store: ISDStore

    let movieID: String

    var body: some View {
        ScrollView {
            LazyVStack {
                if !store.state.movieReviews.reviews.isEmpty {
                    ForEach(store.state.movieReviews.reviews) { review in
                        VStack {
                            HStack {
                                Text(review.title)
                                    .font(.title3)
                                    .lineLimit(2)

                                Spacer()
                            }
                            .padding(.bottom, 10)

                            Text(review.content)
                                .font(.footnote)
                                .lineLimit(review.id == store.state.movieReviews.expandedMovieReviewID ? nil : 1)
                                .animation(.spring(), value: store.state.movieReviews.expandedMovieReviewID)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(10)
                        .background(Color.gray.opacity(0.1))
                        .animation(Animation.easeInOut, value: store.state.movieReviews.expandedMovieReviewID)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(10)
                        .onTapGesture {
                            store.dispatch(ISDAction.movieReview(.tappedReview(review.id)))
                        }
                    }
                } else if let error = store.state.movieReviews.error {
                    Button {
                        store.dispatch(ISDAction.movieReview(.clear))
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
                    Text("Reviews unavailable for movie")
                }
            }
        }
        .onAppear {
            store.dispatch(ISDAction.movieReview(.viewLoaded(self.movieID)))
        }
    }
}

struct MovieReviewsView_Previews: PreviewProvider {
    static var previews: some View {
        MovieReviewsView(movieID: UUID().uuidString)
    }
}
