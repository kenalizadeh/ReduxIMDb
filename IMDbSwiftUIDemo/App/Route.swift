//
//  Route.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import Foundation

enum Route {
    case main
    case search
    case movieDetail(Movie)
}

extension Route: Hashable {
    func hash(into hasher: inout Hasher) {
        switch self {
        case .movieDetail(let value):
            hasher.combine(value)
        default:
            // you can `combine` with some `Hashable` constant, but here it's ok just to skip
            hasher.combine(String(describing: Self.self))
        }
    }
}
