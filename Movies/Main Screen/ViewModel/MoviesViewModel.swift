//
//  MoviesViewModel.swift
//  Movies
//
//  Created by Berkay Yaman on 6.11.2023.
//

import Foundation

class MoviesViewModel {
    
    private let movieService : MovieService
    
    weak var output : MovieViewModelOutput?
    weak var output2: DetailMovieViewModelOutput?
    
    init(movieService: MovieService) {
        self.movieService = movieService
    }

    func fetchMovies(searchText: String) {
        
        if let urlString = URL(string: "https://omdbapi.com/?s=\(searchText)&apikey=7459bd1") {
            movieService.fetchData(from: urlString) { [weak self] (result: Result<Movie, Error>) in
                switch result {
                case .success(let movie):
                    self?.output?.updateView(names: movie.search ?? [])
                case .failure(_):
                    print("Hatata")
                }
            }
        }
    }
    
    func fetchMovieDetail(imdbID: String) {
        if let urlString = URL(string: "https://omdbapi.com/?i=\(imdbID)&apikey=7459bd1") {
            movieService.fetchData(from: urlString) { [weak self] (result: Result<DetailMovie, Error>) in
                switch result {
                case .success(let detailMovie):
                    self?.output2?.updateView(name: detailMovie.title ?? "", poster: detailMovie.poster ?? "", year: detailMovie.year ?? "", director: detailMovie.director ?? "", imdb: detailMovie.imdbRating ?? "", actors: detailMovie.actors ?? "", country: detailMovie.country ?? "")
                case .failure(_):
                    print("Hata 2")
                }
            }
        }
    }
    
    
}
