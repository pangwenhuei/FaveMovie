//
//  ListingState.swift
//  FaveMovie
//
//  Created by TTHQ23-PANGWENHUEI on 14/11/2023.
//

import Foundation

enum MovieFilter: String {
    case releaseDate = "primary_release_date.desc"
    case alphabetical = "original_title.asc"
    case rating = "vote_average.desc"
}

class ListingState: ObservableObject{
    @Published var movies: [MovieModel]?
    @Published var isLoading: Bool = false
    @Published var error: NSError?
    @Published var filter: String = "primary_release_date.desc"
    @Published var page: Int = 1

    private let service: NetworkManager
    
    init(service:NetworkManager = NetworkManager.shared) {
        self.service = service
    }
    
    func loadListing(){
        self.isLoading = true
        
        self.service.fetchListing(orderBy: self.filter, page: self.page) { [weak self] (result) in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let response):
                if self.page == 1 {
                    self.movies = nil
                    self.movies = response.results
                }else {
                    self.movies?.append(contentsOf: response.results)
                }
            case .failure(let error):
                self.error = error as NSError
            }
        }
    }
}
