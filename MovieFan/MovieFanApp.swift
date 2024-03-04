//
//  MovieFanApp.swift
//  MovieFan
//
//  Created by Диана Мишкова on 11.01.24.
//

import SwiftUI

@main
struct MovieFanApp: App {
    let viewModel = MovieViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MoviesView()
                    .environmentObject(viewModel)            
            }
        }
    }
}
