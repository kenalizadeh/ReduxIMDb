//
//  MovieDetail.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 22.08.22.
//

import Foundation

struct MovieDetail: Identifiable {
    let id: String
    let title: String
    let originalTitle: String
    let fullTitle: String
    let year: String
    let image: ImageURLString
    let releaseDate: String
    let runtimeStr: String
    let plotLocal: String
    let directors: [String]
    let writers: [String]
    let stars: String
    let actors: [Actor]
    let genres: String
    let similarMovies: Movies
    let imageURLs: [String]
}

extension MovieDetail {
    init(from dto: MovieDetailResponseDTO) {
        self.id = dto.id
        self.title = dto.title
        self.originalTitle = dto.originalTitle
        self.fullTitle = dto.fullTitle
        self.year = dto.year
        self.image = dto.image
        self.releaseDate = dto.releaseDate
        self.runtimeStr = dto.runtimeStr
        self.plotLocal = dto.plotLocal
        self.directors = dto.directorList.map(\.name)
        self.writers = dto.writerList.map(\.name)
        self.stars = dto.stars
        self.actors = dto.actorList.map(MovieDetail.Actor.init(from:))
        self.genres = dto.genres
        self.similarMovies = dto.similars.map(Movie.init(from:))
        self.imageURLs = dto.images.items.map(\.image)
    }
}

extension MovieDetail {
    struct Actor: Identifiable {
        let id: String
        let name: String
        let character: String
        let image: String

        init(from dto: MovieActorDTO) {
            self.id = dto.id
            self.name = dto.name
            self.character = dto.asCharacter
            self.image = dto.image
        }
    }
}
