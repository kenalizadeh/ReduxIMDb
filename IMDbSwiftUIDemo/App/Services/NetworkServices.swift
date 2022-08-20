//
//  NetworkServices.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import SwiftUI
import Combine

class PopularMoviesNetworkService: BaseNetworkService<EmptyRequestDTO, PopularMoviesResponseDTO> {
    // Test URL https://imdb-api.com/en/API/PopularMovies/k_wvico135
    override var path: String { "MostPopularMovies/\(NetworkConstants.apiToken)" }
}

class SearchNetworkService: BaseNetworkService<EmptyRequestDTO, SearchResponseDTO> {
    private var _searchQuery: String = ""

    // https://imdb-api.com/en/API/Search/k_wvico135/inception%202010
    override var path: String { "Search/\(NetworkConstants.apiToken)/\(self._searchQuery)" }

    func fetch(query: String) {
        self._searchQuery = query
        print(":LOG: URL", url.absoluteString, path)
        super.fetch()
    }

    func call(query: String) {
        self._searchQuery = query
        print(":LOG: URL", url.absoluteString, path)
        super.call()
    }
}
