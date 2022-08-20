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
    private var _searchQuery: String = ""

    override var path: String { "Search/\(NetworkConstants.apiToken)/\(self._searchQuery)" }

    func send(query: String) {
        self._searchQuery = query
        print(":LOG: URL", url.absoluteString, path)
        super.send()
    }
}
