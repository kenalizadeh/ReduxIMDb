//
//  ImageSize.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 22.08.22.
//

import Foundation

typealias ImageURLString = String

extension ImageURLString {
    func resized(_ size: ImageSize) -> ImageURLString {
        "https://imdb-api.com/API/ResizeImage?apiKey=k_wvico135&size=\(size.size.width)x\(size.size.height)&url=" + self
    }
}

enum ImageSize {
    case small
    case medium
    case large

    var size: (width: Int, height: Int) {
        switch self {
        case .small: return (width: 130, height: 180)

        case .medium: return (width: 253, height: 350)

        case .large: return (width: 740, height: 1024)
        }
    }
}
