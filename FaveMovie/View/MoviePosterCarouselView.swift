//
//  MoviePosterCarouselView.swift
//  FaveMovie
//
//  Created by TTHQ23-PANGWENHUEI on 14/11/2023.
//

import SwiftUI

struct MoviePosterCarouselView: View {
    let title: String
    let movies: [MovieModel]
    @Binding var selectedMovie: MovieModel?
    @State var columnCount: Int = 2
    let layout = [
        GridItem(.adaptive(minimum: 180)),
    ]
    @Binding var scrollPosition: CGPoint?
    @Binding var page: Int?
    let onEndOfList: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ScrollView(.vertical) {
                LazyVGrid(columns: layout, spacing: 20) {
                    ForEach(self.movies) {  movie in
                        MoviePosterCard(movie: movie)
                            .frame(width: 180, height: 306)
                            .onTapGesture {
                                self.selectedMovie = movie
                            }
                    }
                }
                .padding(.horizontal, 10)
                .padding(.bottom)
            }
            .coordinateSpace(name: "scroll")
            .background(GeometryReader { geometry in
                Color.clear
                    .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin)
            })
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                self.scrollPosition = value
                if(self.scrollPosition?.y ?? 0.0 < CGFloat(-2400*(self.page ?? 1))){
                    onEndOfList()
                }
            }
        }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
    }
}

//#Preview {
//    MoviePosterCarouselView(title: "Now Playing", movies: [MovieModel(page:"1", adult: false, backdropPath: "test", posterPath: "test", id: 1, title: "test", video: false)], selectedMovie: .constant(nil))
//}
