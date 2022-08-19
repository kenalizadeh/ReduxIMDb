//
//  DashboardNetworkService.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import Foundation

class PopularMoviesNetworkService: BaseNetworkService<EmptyRequestDTO, PopularMoviesResponseDTO> {
    // Test URL https://imdb-api.com/en/API/PopularMovies/k_wvico135
    override var path: String { "MostPopularMovies/\(NetworkConstants.apiToken)" }
}
