//
//  MovieDetailResponseDTO.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 22.08.22.
//

import Foundation

// MARK: - MovieDetailResponseDTO
struct MovieDetailResponseDTO: ResponseDTOProtocol {
    let id: String
    let title: String
    let originalTitle: String
    let fullTitle: String
    let year: String
    let image: String
    let releaseDate: String
    let runtimeStr: String?
    let plotLocal: String
    let directorList: [MovieWriterDirectorDTO]
    let writerList: [MovieWriterDirectorDTO]
    let stars: String
    let actorList: [MovieActorDTO]
    let genres: String
    let images: MovieImagesDTO
    let similars: [SimilarMoviesDTO]
}

// MARK: - MovieActorDTO
struct MovieActorDTO: ResponseDTOProtocol {
    let id: String
    let image: String
    let name: String
    let asCharacter: String
}

struct MovieWriterDirectorDTO: ResponseDTOProtocol {
    let id: String
    let name: String
}

// MARK: - MovieImagesDTO
struct MovieImagesDTO: ResponseDTOProtocol {
    let title: String
    let fullTitle: String
    let items: [MovieImagesItemDTO]
    let errorMessage: String
}

// MARK: - MovieImagesItemDTO
struct MovieImagesItemDTO: ResponseDTOProtocol {
    let title: String
    let image: String
}

// MARK: - SimilarMoviesDTO
struct SimilarMoviesDTO: ResponseDTOProtocol {
    let id: String
    let title: String
    let image: String
    let imDBRating: String?
}
