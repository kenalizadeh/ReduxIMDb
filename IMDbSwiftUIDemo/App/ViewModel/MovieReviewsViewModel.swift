//
//  MovieReviewsViewModel.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 21.08.22.
//

import Combine

class MovieReviewsViewModel: ObservableObject {
    @Published
    var networkService: MovieReviewsNetworkService

    @Published
    var isLoading: Bool = false

    @Published
    var reviews: MovieReviews = []

    @Published
    var expandedReviewID: String = ""

    var cancellables: [AnyCancellable] = []

    let movieID: String

    init(movieID: String) {
        self.movieID = movieID
        self.networkService = MovieReviewsNetworkService(movieID: movieID)

        networkService
            .$responseDTO
            .compactMap { $0 }
            .map(\.items)
            .map { $0.map(MovieReview.init(from:)) }
            .assign(to: &$reviews)

        networkService
            .$isLoading
            .assign(to: &$isLoading)
    }
}
