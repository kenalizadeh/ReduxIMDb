//
//  MovieDetailView.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 19.08.22.
//

import SwiftUI

struct MovieDetailView: View {
    @EnvironmentObject var store: ISDStore

    let movie: Movie

    var body: some View {
        VStack {
            Text(movie.fullTitle)

            Text(movie.year)

            AsyncImage(url: URL(string: movie.resizedImageURL)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 60)
            } placeholder: {
                ProgressView()
            }
        }
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(movie: Movie.init(from: .init(id: "", rank: "", rankUpDown: "", title: "", fullTitle: "", year: "", image: "", imDBRating: nil, imDBRatingCount: nil, crew: "")))
    }
}
