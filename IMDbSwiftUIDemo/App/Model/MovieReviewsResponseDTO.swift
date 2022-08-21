//
//  MovieReviewsResponseDTO.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 21.08.22.
//

import Foundation

// MARK: - MovieReviewsResponseDTO
struct MovieReviewsResponseDTO: ResponseDTOProtocol {
    let imDBID: String?
    let title: String
    let fullTitle: String
    let type: String
    let year: String
    let items: [MovieReviewDTO]
    let errorMessage: String
}

// MARK: - MovieReviewDTO
struct MovieReviewDTO: ResponseDTOProtocol {
    let username: String
    let userURL: String?
    let reviewLink: String
    let warningSpoilers: Bool
    let date, rate, helpful, title: String
    let content: String
}
