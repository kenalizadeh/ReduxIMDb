//
//  MovieReviewsView.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 21.08.22.
//

import SwiftUI

struct MovieReviewsView: View {
    @EnvironmentObject var store: ISDStore

    @StateObject
    var viewModel: MovieReviewsViewModel

    let movieID: String

    init(movieID: String) {
        self.movieID = movieID
        self._viewModel = StateObject(wrappedValue: MovieReviewsViewModel(movieID: movieID))
    }

    var body: some View {
        ScrollView {
            LazyVStack {
                if viewModel.isLoading {
                    HStack {
                        Spacer()

                        ProgressView("Searching...")

                        Spacer()
                    }
                }

                ForEach(viewModel.reviews) { review in
                    VStack {
                        HStack {
                            Text(review.title)
                                .font(.title3)
                                .lineLimit(2)

                            Spacer()
                        }
                        .padding(.bottom, 10)

                        if review.id == viewModel.expandedReviewID {
                            Text(review.content)
                                .font(.footnote)
                                .lineLimit(nil)
                                .multilineTextAlignment(.leading)
                        } else {
                            Text(review.content)
                                .font(.footnote)
                                .lineLimit(1)
                        }
                    }
                    .padding(10)
                    .background(Color.gray.opacity(0.1))
                    .animation(Animation.easeInOut, value: viewModel.expandedReviewID)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(10)
                    .simultaneousTapGesture {
                        viewModel.expandedReviewID = viewModel.expandedReviewID == review.id ? "" : review.id
                    }
                }
            }
        }
        .onAppear {
            viewModel
                .networkService
                .send()
        }
    }
}

struct MovieReviewsView_Previews: PreviewProvider {
    static var previews: some View {
        MovieReviewsView(movieID: UUID().uuidString)
    }
}
