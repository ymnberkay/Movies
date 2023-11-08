//
//  DetailMovieViewModelOutput.swift
//  Movies
//
//  Created by Berkay Yaman on 7.11.2023.
//

import Foundation

protocol DetailMovieViewModelOutput: AnyObject {
    func updateView(name: String, poster: String, year: String, director: String, imdb: String, actors: String, country: String)
}
