//
//  MovieDetailViewModel.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 22.08.22.
//

import Foundation

class MovieDetailViewModel: ObservableObject {
    @Published
    var networkService: MovieDetailNetworkService

    @Published
    var isLoading: Bool = false

    @Published
    var hasError: Bool = false

    @Published
    var movie: MovieDetail?

    let movieID: String

    init(movieID: String) {
        self.movieID = movieID
        self.networkService = MovieDetailNetworkService(movieID: movieID)

        networkService
            .$responseDTO
            .compactMap { $0 }
            .map(MovieDetail.init(from:))
            .assign(to: &$movie)

        networkService
            .$isLoading
            .assign(to: &$isLoading)

        networkService
            .$hasError
            .assign(to: &$hasError)
    }
}
