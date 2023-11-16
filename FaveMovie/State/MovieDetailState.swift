//
//  MovieDetailState.swift
//  FaveMovie
//
//  Created by TTHQ23-PANGWENHUEI on 14/11/2023.
//

import Foundation
import SwiftUI

class MovieDetailState: ObservableObject {
    
    private let movieService: NetworkManager
    @Published var movie: MovieModel?
    @Published var isLoading = false
    @Published var error: NSError?
    
    init(movieService: NetworkManager = NetworkManager.shared) {
        self.movieService = movieService
    }
    
    func loadMovie(id: Int) {
        self.movie = nil
        self.isLoading = false
        self.movieService.fetchDetail(id: id) {[weak self] (result) in
            guard let self = self else { return }
            
            self.isLoading = false
            switch result {
            case .success(let movie):
                self.movie = movie
            case .failure(let error):
                self.error = error as NSError
            }
        }
    }
}
