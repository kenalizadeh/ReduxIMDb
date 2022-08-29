//
//  Route.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import Foundation

enum Route {
    case dashboard
    case movieDetail(Movie)
    case movieReviews(Movie)
}

extension Route: Hashable {
    func hash(into hasher: inout Hasher) {
        switch self {
        case .movieDetail(let value), .movieReviews(let value):
            hasher.combine(value)

        default:
            hasher.combine(String(describing: Self.self))
        }
    }
}
