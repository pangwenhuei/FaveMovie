//
//  MoviePosterCard.swift
//  FaveMovie
//
//  Created by TTHQ23-PANGWENHUEI on 14/11/2023.
//

import Foundation
import SwiftUI

struct MoviePosterCard: View {
    
    let movie: MovieModel
    @ObservedObject var imageLoader = ImageLoader()
    
    init(movie: MovieModel) {
        self.movie = movie
        self.imageLoader.loadImage(with: movie.posterURL)
    }
    
    var body: some View {
        ZStack {
            if self.imageLoader.image != nil {
                Image(uiImage: self.imageLoader.image!)
                    .resizable()
                    .aspectRatio(180/306, contentMode: .fill)
                    .cornerRadius(8)
                    .shadow(radius: 8)
                    .overlay(TitleOverlay(title: movie.title), alignment: .topLeading)
                    .overlay(PopularityOverlay(popularity: "Popularity: \(movie.popularity ?? 0.0)"), alignment: .bottomTrailing)
                .clipped()
                
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .cornerRadius(8)
                    .shadow(radius: 8)
                    .overlay(TitleOverlay(title: movie.title), alignment: .topLeading)
                    .overlay(PopularityOverlay(popularity: "Popularity: \(movie.popularity ?? 0.0)"), alignment: .bottomTrailing)
            }
        }
    }
}

struct TitleOverlay: View {
    let title: String
    
    init(title: String) {
        self.title = title
    }
    
    var body: some View {
        ZStack {
            Text(self.title)
                .font(.callout)
                .padding(6)
                .foregroundColor(.white)
        }.background(Color.black.opacity(0.5))
        .opacity(0.8)
        .cornerRadius(10.0)
        .padding(6)
    }
}

struct PopularityOverlay: View {
    let popularity: String
    
    init(popularity: String) {
        self.popularity = popularity
    }
    
    var body: some View {
        ZStack {
            Text(self.popularity)
                .font(.footnote)
                .padding(6)
                .foregroundColor(.white)
        }.background(Color.black.opacity(0.5))
        .opacity(0.8)
        .cornerRadius(10.0)
        .padding(6)
    }
}

//struct MoviePosterCard_Previews: PreviewProvider {
//    static var previews: some View {
//        MoviePosterCard(movie: MovieModel(page:"1",adult: false, backdropPath: "test", posterPath: "test", id: 1, title: "test", video: false))
//    }
//}
