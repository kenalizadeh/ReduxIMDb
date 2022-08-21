//
//  SearchViewModel.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 20.08.22.
//

import Combine

class SearchViewModel: ObservableObject {
    @Published
    var networkService: SearchNetworkService = .init()

    @Published
    var searchText: String = ""

    @Published
    var isSearching: Bool = false

    @Published
    var movies: Movies = []

    var cancellables: [AnyCancellable] = []

    init() {
        networkService
            .$responseDTO
            .compactMap { $0 }
            .map(\.results)
            .map { $0.map(Movie.init(from:)) }
            .assign(to: &$movies)

        networkService
            .$isLoading
            .assign(to: &$isSearching)

        $searchText
            .assign(to: \.searchQuery, on: networkService)
            .store(in: &cancellables)
    }
}
