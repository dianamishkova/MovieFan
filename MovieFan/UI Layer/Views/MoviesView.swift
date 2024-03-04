//
//  ContentView.swift
//  MovieFan
//
//  Created by Диана Мишкова on 11.01.24.
//

import SwiftUI
import Charts
import CoreData

struct MoviesView: View {
    @EnvironmentObject var viewModel: MovieViewModel
    
    var body: some View {
        TabView {
            List {
                Section(header: Text("Popular Movies")) {
                    ForEach(viewModel.movies) { movie in
                        NavigationLink(destination: MovieDetailsView(movie: movie)) {
                            MovieCardView(movie: movie)
                        }
                        
                    }
                }
            }
            .tabItem {
                Label("Movies", systemImage: "movieclapper")
                
            }
            .onAppear {
                let lastDate = UserDefaults.standard.value(forKey: "lastAppearedDate")
                print("last date = \(lastDate)")
                viewModel.getMovies()
                UserDefaults.standard.setValue(Date(), forKey: "lastAppearedDate")
            }

            Chart {
                ForEach(viewModel.movieRatings.prefix(15)) { movie in
                    RectangleMark(
                        x: .value("Movie", movie.title),
                        y: .value("Vote Average", movie.voteAverage),
                        width: .ratio(0.7),
                        height: 7
                    )

                    BarMark(
                        x: .value("Movie", movie.title),
                        yStart: .value("Min Vote", movie.minVote()),
                        yEnd: .value("Max Vote", movie.maxVote()),
                        width: .ratio(0.4)
                    )
                }
                .foregroundStyle(Color.gray)
                .opacity(0.3)
                
                RuleMark(
                    y: .value("Average", viewModel.getMovieRatingVoteAverage())
                )
                .foregroundStyle(.purple)
                .lineStyle(StrokeStyle(lineWidth: 3))
                .annotation(position: .top, alignment: .leading) {
                    Text("Average \(viewModel.getMovieRatingVoteAverage())")
                        .foregroundStyle(.blue)
                        .font(.headline)
                }
            }
            .chartYScale(domain: 0...35)
            .chartYAxis {
                AxisMarks(preset: .extended,
                          position: .leading)
            }
            .chartPlotStyle { plot in
                plot
                    .frame(height: 400)
                    .border(.purple, width: 2)
                    .background(.pink.opacity(0.1))
            }
            .padding(15)
            .onAppear {
                viewModel.getMovieRating()
            }
            .tabItem {
                Label("Ratings", systemImage: "chart.bar.xaxis")
            }
        }
        
        
        .navigationTitle("Movies")
    }
}

struct MoviesView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesView()
            .environmentObject(MovieViewModel())
    }
}
