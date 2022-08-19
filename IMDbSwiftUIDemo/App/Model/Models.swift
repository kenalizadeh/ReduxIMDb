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
    let year: String
    let imageURL: String
    let resizedImageURL: String

    init(from dto: MovieResponseDTO) {
        self.id = dto.id
        self.title = dto.title
        self.fullTitle = dto.fullTitle
        self.year = dto.year
        self.imageURL = dto.image
        #if MOCK
            self.resizedImageURL = "https://picsum.photos/200/300"
        #else
            self.resizedImageURL = "https://imdb-api.com/API/ResizeImage?apiKey=k_wvico135&size=130x180&url=" + dto.image
        #endif
    }
}

extension Movie: Identifiable, Equatable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }
}

extension Movie: Hashable {
    
}

typealias Movies = [Movie]
