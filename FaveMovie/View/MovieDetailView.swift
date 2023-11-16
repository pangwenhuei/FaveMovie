//
//  MovieDetailView.swift
//  FaveMovie
//
//  Created by TTHQ23-PANGWENHUEI on 14/11/2023.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: MovieModel
    @ObservedObject private var movieDetailState = MovieDetailState()
    
    init(movie: MovieModel) {
        self.movie = movie
        self.movieDetailState.loadMovie(id: self.movie.id)
    }
    
    var body: some View {
        ZStack {
            if movieDetailState.movie != nil {
                MovieDetailListView(movie: self.movieDetailState.movie!)
            }
            
            LoadingView(isLoading: self.movieDetailState.isLoading, error: self.movieDetailState.error) {
                self.movieDetailState.loadMovie(id: self.movie.id)
            }
        }
        .frame(minWidth: 300)
    }
}

struct MovieDetailListView: View {
    
    let movie: MovieModel
    private let imageLoader = ImageLoader()
    @State private var isShowingWebView: Bool = false
    @State private var isLoading = true
    @State private var error: Error? = nil
    
    var body: some View {
        ScrollView {
            
            VStack(alignment: .leading, spacing: 16) {
                MovieDetailImage(imageLoader: imageLoader, imageURL: self.movie.backdropURL)
                Text(movie.title)
                    .font(.largeTitle)
                
                Divider()
                
                if movie.overview != "" {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Synopsis")
                            .font(.headline)
                        Text(movie.overview ?? "")
                            .lineLimit(10)
                    }
                    Divider()
                }
                
                if movie.genres != nil && movie.genres!.count > 0 {
                    HStack(alignment: .top, spacing: 4) {
                    
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Genres").font(.headline)
                                .padding(.bottom, 4)
                            VStack(alignment: .leading, spacing: 4) {
                                ForEach(self.movie.genres!.prefix(9)) { genre in
                                    Text("· \(genre.name)")
                                }
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        
                    }
                    Divider()
                }
                
                if movie.originalLanguage != "" {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Language")
                            .font(.headline)
                        Text(movie.originalLanguage?.capitalized ?? "N/A")
                            .lineLimit(10)
                    }
                    Divider()
                }
                
                if movie.durationText != "" {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Duration")
                            .font(.headline)
                        Text(movie.durationText)
                            .lineLimit(1)
                    }
                    Divider()
                }
                
                HStack {
                    Spacer()
                    Button(action: {
                        isShowingWebView = true
                    })
                    {
                        Text("Book the movie")
                    }
                    .buttonStyle(BlueButton())
                    .sheet(isPresented: $isShowingWebView) {
                        Button(action: {
                            isShowingWebView = false
                        }) {
                            Text("Close")
                        }
                        .foregroundColor(Color(uiColor: .systemBlue))
                        .buttonStyle(PlainButtonStyle())
                        .padding(.vertical)
                        
                        Divider()
                        
                        ZStack {
                            if let error = error {
                                Text(error.localizedDescription)
                                    .foregroundColor(.pink)
                            } else {
                                WebView(
                                    url: URL(string: "https://www.cathaycineplexes.com.sg/")!,
                                    isLoading: $isLoading,
                                    error: $error
                                )
                                .edgesIgnoringSafeArea(.all)
                                
                                if isLoading {
                                    ProgressView()
                                }
                            }
                        }
                    }
                    Spacer()
                }
            }
            .padding()
        }
    }
}

struct MovieDetailImage: View {
    
    @ObservedObject var imageLoader: ImageLoader
    let imageURL: URL
    
    var body: some View {
        ZStack {
            Rectangle().fill(Color.gray.opacity(0.3))
            if self.imageLoader.image != nil {
                Image(uiImage: self.imageLoader.image!)
                    .resizable()
            }
        }
        .aspectRatio(16/9, contentMode: .fit)
        .cornerRadius(8)
            
        .onAppear {
            self.imageLoader.loadImage(with: self.imageURL)
        }
    }
}

struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.blue)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

//#Preview {
//    MovieDetailView(movie: MovieModel(page: "1", adult: false, backdropPath: "test", posterPath: "test", id: 1, title: "test", video: false))
//}
