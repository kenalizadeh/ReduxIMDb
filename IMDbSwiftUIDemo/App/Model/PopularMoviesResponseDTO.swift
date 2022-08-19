//
//  PopularMoviesResponse.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import Foundation

// MARK: - PopularMovies
struct PopularMoviesResponseDTO: ResponseDTOProtocol {
    let items: [MovieResponseDTO]
    let errorMessage: String
}

// MARK: - Movie
struct MovieResponseDTO: ResponseDTOProtocol, Identifiable {
    let id: String
    let rank: String
    let rankUpDown: String
    let title: String
    let fullTitle: String
    let year: String
    let image: String
    let imDBRating: String?
    let imDBRatingCount: String?
    let crew: String
}
