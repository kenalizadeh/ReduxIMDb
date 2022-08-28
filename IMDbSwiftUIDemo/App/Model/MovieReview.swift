//
//  MovieReview.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 21.08.22.
//

import Foundation

struct MovieReview: ResponseDTOProtocol {
    let username: String
    let userURL: String?
    let reviewLink: String
    let warningSpoilers: Bool
    let date: String
    let rate: String
    let helpful: String
    let title: String
    let content: String
}

extension MovieReview {
    init(from dto: MovieReviewDTO) {
        self.username = dto.username
        self.userURL = dto.userURL
        self.reviewLink = dto.reviewLink
        self.warningSpoilers = dto.warningSpoilers
        self.date = dto.date
        self.rate = dto.rate
        self.helpful = dto.helpful
        self.title = dto.title
        self.content = dto.content
    }
}

extension MovieReview: Identifiable {
    var id: String { reviewLink }
}

typealias MovieReviews = [MovieReview]
