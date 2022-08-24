//
//  DashboardViewModel.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 21.08.22.
//

import Combine

//class DashboardViewModel: ObservableObject {
//    @Published
//    var networkService: PopularMoviesNetworkService = .init()
//
//    @Published
//    var isLoading: Bool = false
//
//    @Published
//    var movies: Movies = []
//
//    var cancellables: [AnyCancellable] = []
//
//    init() {
//        networkService
//            .$responseDTO
//            .compactMap { $0 }
//            .map(\.items)
//            .map { $0.map(Movie.init(from:)) }
//            .assign(to: &$movies)
//
//        networkService
//            .$isLoading
//            .assign(to: &$isLoading)
//    }
//}
