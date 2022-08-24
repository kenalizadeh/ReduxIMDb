//
//  HorizontalMovieCell.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 24.08.22.
//

import SwiftUI

struct HorizontalMovieCell: View {
    let movie: MovieDetail.SimilarMovie

    var body: some View {
        VStack(spacing: 0) {
            AsyncImage(url: URL(string: self.movie.image.resized(.medium))) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
            .padding(.horizontal, 10)

            ZStack {
                Color.black.opacity(0.5)

                Text(self.movie.title)
                    .font(.footnote)
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
            .frame(height: 30)
        }
    }
}

struct HorizontalMovieCell_Previews: PreviewProvider {
    static let urls = [
        "https://m.media-amazon.com/images/M/MV5BNWI3ODQ3M2YtZWIwNC00MDVmLWFkNDMtODE3Mzg2YmFlYjZhXkEyXkFqcGdeQXVyMjI2NTcxNTc@._V1_Ratio0.7273_AL_.jpg",
        "https://m.media-amazon.com/images/M/MV5BYWI2ZDRjYjEtOWJiOS00NWVjLWI1MjAtNWNiMzAwNGFmNjljXkEyXkFqcGdeQXVyODEwMTc2ODQ@._V1_Ratio0.7273_AL_.jpg",
        "https://m.media-amazon.com/images/M/MV5BNjIyNmE1YjctMmE4Mi00NWY2LTkyMmUtNzFkZThmMzU5NWYyXkEyXkFqcGdeQXVyMjIxMzA2MTI@._V1_Ratio1.7727_AL_.jpg",
        "https://m.media-amazon.com/images/M/MV5BMTQ3NzAxMjM0Ml5BMl5BanBnXkFtZTcwMjE4NzAzMQ@@._V1_Ratio0.7273_AL_.jpg",
        "https://m.media-amazon.com/images/M/MV5BOTg0YTY1MzktMTA3Yi00YzIwLWIwNmUtMzgzYzhkMGNkZWJlXkEyXkFqcGdeQXVyMzk3NzQ1MTI@._V1_Ratio1.5909_AL_.jpg"
    ]

    static var previews: some View {
        GeometryReader { proxy in
            VStack {
                Spacer()

                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(urls, id: \.self) { url in
                            NavigationLink(value: "asdfg") {
                                HorizontalMovieCell(
                                    movie: .init(
                                        from: .init(
                                            id: "tt13314558",
                                            title: "Day Shift",
                                            image: "https://m.media-amazon.com/images/M/MV5BYWI2ZDRjYjEtOWJiOS00NWVjLWI1MjAtNWNiMzAwNGFmNjljXkEyXkFqcGdeQXVyODEwMTc2ODQ@._V1_Ratio0.7273_AL_.jpg",
                                            imDBRating: nil
                                        )
                                    )
                                )
                                .frame(width: proxy.size.height / 6, height: proxy.size.height / 3)
                                .clipped()
                            }
                        }
                    }
                }
            }
        }
    }
}
