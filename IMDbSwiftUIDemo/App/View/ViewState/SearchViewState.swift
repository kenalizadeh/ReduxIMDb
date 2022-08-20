//
//  SearchViewState.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 20.08.22.
//

import Combine

class SearchViewState: ObservableObject {
    @Published
    var networkService: SearchNetworkService = .init()

    @Published
    var searchText: String = ""

    @Published
    var isSearching: Bool = false
}
