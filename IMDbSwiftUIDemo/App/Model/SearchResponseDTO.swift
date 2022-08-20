//
//  SearchResponseDTO.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 20.08.22.
//

import Foundation

// MARK: - SearchResponseDTO
struct SearchResponseDTO: ResponseDTOProtocol {
    let searchType: SearchType
    let expression: String?
    let results: [SearchResponseMovieDTO]
    let errorMessage: String
}

// MARK: - SearchResponseMovieDTO
struct SearchResponseMovieDTO: ResponseDTOProtocol {
    let id: String
    let resultType: SearchType
    let image: String
    let title: String
}

enum SearchType: String, ResponseDTOProtocol {
    case title = "Title"
}
