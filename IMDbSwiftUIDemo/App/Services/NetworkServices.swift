//
//  NetworkServices.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import SwiftUI
import Combine

// Test URL https://imdb-api.com/en/API/PopularMovies/k_wvico135
class PopularMoviesNetworkService: BaseNetworkService<EmptyRequestDTO, PopularMoviesResponseDTO> {
    override var path: String { "MostPopularMovies/\(NetworkConstants.apiToken)" }
}

// Test URL https://imdb-api.com/en/API/Search/k_wvico135/inception%202010
class SearchNetworkService: BaseNetworkService<EmptyRequestDTO, SearchResponseDTO> {
    var searchQuery: String = ""

    init(searchQuery: String) {
        self.searchQuery = searchQuery
    }

    override var path: String { "Search/\(NetworkConstants.apiToken)/\(self.searchQuery)" }
}

class MovieReviewsNetworkService: BaseNetworkService<EmptyRequestDTO, MovieReviewsResponseDTO> {
    let movieID: String

    override var path: String { "Reviews/\(NetworkConstants.apiToken)/\(self.movieID)" }

    init(movieID: String) {
        self.movieID = movieID
    }
}

class MovieDetailNetworkService: BaseNetworkService<EmptyRequestDTO, MovieDetailResponseDTO> {
    let movieID: String

    override var path: String { "Title/\(NetworkConstants.apiToken)/\(self.movieID)/FullCast,Images" }

    init(movieID: String) {
        self.movieID = movieID
    }
}
