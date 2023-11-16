//
//  HomeScreen.swift
//  FaveMovie
//
//  Created by TTHQ23-PANGWENHUEI on 14/11/2023.
//

import SwiftUI

struct HomeScreen: View {
    @ObservedObject private var listingState = ListingState()
    
    @State var selectedMovie: MovieModel?
    let categories = ["Release date", "Alphabetical", "Rating"]
    @State private var categorizeBy = "Release date"
    @State var scrollPosition: CGPoint?
    @State var page: Int?
    
    var body: some View {
        Picker("Select sort", selection: $categorizeBy) {
            ForEach(categories, id: \.self) {
                Text($0)
            }
        }
        .onChange(of: categorizeBy) { previous, current in
            if(previous != current){
                self.page = 1
            }
            
            switch categories.firstIndex(of: current){
            case 0:
                self.listingState.filter = MovieFilter.releaseDate.rawValue
            case 1:
                self.listingState.filter = MovieFilter.alphabetical.rawValue
            case 2:
                self.listingState.filter = MovieFilter.rating.rawValue
            default: break
            }
            
            self.listingState.page = 1
            self.listingState.loadListing()
        }
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 24) {
                if listingState.movies != nil {
                    MoviePosterCarouselView(title: "Home Screen", movies: listingState.movies ?? [MovieModel](), selectedMovie: $selectedMovie, scrollPosition: $scrollPosition, page: $page, onEndOfList: {
                        self.page = (self.page ?? 1) + 1
                        self.listingState.page = self.page ?? 1
                        self.listingState.loadListing()
                    })
                }else {
                    LoadingView(isLoading: listingState.isLoading, error: listingState.error) {
                        listingState.loadListing()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear{
            self.listingState.loadListing()
        }
        .sheet(item: self.$selectedMovie) { movie in
            NavigationView {
                VStack(spacing: 0) {
                    Button(action: {
                        self.selectedMovie = nil
                    }) {
                        Text("Close")
                    }
                    .foregroundColor(Color(uiColor: .systemBlue))
                    .buttonStyle(PlainButtonStyle())
                    .padding(.vertical)
                    
                    Divider()
                    MovieDetailView(movie: movie)
                }
            }
            .navigationViewStyle(DefaultNavigationViewStyle())
            .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height-100)
        }
        .refreshable {
            self.page = 1
            self.listingState.page = 1
            self.listingState.loadListing()
        }
    }
}

#Preview {
    HomeScreen()
}
