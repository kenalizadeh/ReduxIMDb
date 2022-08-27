//
//  MovieCell.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 27.08.22.
//

import SwiftUI

struct MovieCell: View {
    let movie: Movie

    var body: some View {
        VStack {
            HStack {
                Text(movie.fullTitle)
                    .padding(.leading, 5)
                    .foregroundColor(Color.black)

                Spacer()

                AsyncImage(url: URL(string: movie.imageURL.resized(.small))) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 60)
                } placeholder: {
                    ProgressView()
                }
            }
            .frame(height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .padding(10)
            .shadow(radius: 6)

            Divider()
                .padding(.horizontal, 10)
        }
    }
}

struct MovieCell_Previews: PreviewProvider {
    static var previews: some View {
        MovieCell(movie: Movie.init(id: "tt13314558", title: "", fullTitle: "", imageURL: ""))
    }
}
