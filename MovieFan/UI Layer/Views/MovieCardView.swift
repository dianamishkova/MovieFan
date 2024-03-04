//
//  MovieCardView.swift
//  MovieFan
//
//  Created by Диана Мишкова on 12.01.24.
//

import SwiftUI

struct MovieCardView: View {
    var movie: Movie
    var body: some View {
        VStack {
            HStack {
                Text(movie.title)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                Spacer()
                let imageURL = URL(string: movie.getLogoURL())
                AsyncImage(url: imageURL) { image in
                    image.scaledToFit()
                } placeholder: {
                    Image("blue_square")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
            }
            HStack {
                Text(movie.releaseDate)
                    .font(.caption)
                    .foregroundColor(.accentColor)
                Spacer()
            }
        }
    }
}

struct MovieCardView_Previews: PreviewProvider {
    static var previews: some View {
        MovieCardView(movie: Movie(id: 1, title: "Terminataor 2", overview: "Terminator T-100 and the rest of the crew", imageURLSuffix: "/8uO0gUM8aNqYLs1OsTBQiXu0fEv.jpg", releaseDate: "1997-10-01"))
    }
}
