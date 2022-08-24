//
//  Models.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 17.08.22.
//

import Foundation

struct Movie {
    let id: String
    let title: String
    let fullTitle: String
    let imageURL: ImageURLString
}

extension Movie {
    init(from dto: MovieResponseDTO) {
        self.id = dto.id
        self.title = dto.title
        self.fullTitle = dto.fullTitle
        self.imageURL = dto.image
    }

    init(from dto: SearchResponseMovieDTO) {
        self.id = dto.id
        self.title = dto.title
        self.fullTitle = dto.title
        self.imageURL = dto.image
    }

    init(from detail: MovieDetail) {
        self.id = detail.id
        self.title = detail.title
        self.fullTitle = detail.fullTitle
        self.imageURL = detail.image
    }

    init(from dto: SimilarMoviesDTO) {
        self.id = dto.id
        self.title = dto.title
        self.fullTitle = dto.title
        self.imageURL = dto.image
    }
}

extension Movie: Identifiable, Equatable, Hashable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }
}

typealias Movies = [Movie]
