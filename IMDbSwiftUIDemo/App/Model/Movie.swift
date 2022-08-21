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
    let imageURL: String
    let resizedImageURL: String
}

extension Movie {
    init(from dto: MovieResponseDTO) {
        self.id = dto.id
        self.title = dto.title
        self.fullTitle = dto.fullTitle
        self.imageURL = dto.image
        #if MOCK
        self.resizedImageURL = "https://picsum.photos/200/300"
        #else
        self.resizedImageURL = "https://imdb-api.com/API/ResizeImage?apiKey=k_wvico135&size=130x180&url=" + dto.image
        #endif
    }

    init(from dto: SearchResponseMovieDTO) {
        self.id = dto.id
        self.title = dto.title
        self.fullTitle = dto.title
        self.imageURL = dto.image
        #if MOCK
        self.resizedImageURL = "https://picsum.photos/200/300"
        #else
        self.resizedImageURL = "https://imdb-api.com/API/ResizeImage?apiKey=k_wvico135&size=130x180&url=" + dto.image
        #endif
    }
}

extension Movie: Identifiable, Equatable, Hashable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }
}

typealias Movies = [Movie]
