//
//  MovieDetailsView.swift
//  MovieFan
//
//  Created by Диана Мишкова on 13.01.24.
//

import SwiftUI

struct MovieDetailsView: View {
    var movie: Movie
    var body: some View {
        ScrollView {
            VStack {
                let url = URL(string: movie.getLargeImageURL())
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .frame(width: 350, height: 450, alignment: .center)
                } placeholder: {
                    Image("blue_square")
                        .resizable()
                        .frame(width: 250, height: 250)
                }
                Spacer()
                Text("Realesed: \(movie.releaseDate)")
                Spacer()
                Text(movie.overview)
                    .font(.body)
            }
            .accessibilityLabel("Movie Details")
        }
        .navigationTitle(movie.title)
        .padding()
    }
    
}

struct MovieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailsView(movie: Movie(id: 1, title: "Terminataor 2", overview: "Terminator T-100 and the rest of the crew", imageURLSuffix: "/8uO0gUM8aNqYLs1OsTBQiXu0fEv.jpg", releaseDate: "1997-10-01"))
    }
}
