//
//  MovieService.swift
//  Movies
//
//  Created by Berkay Yaman on 7.11.2023.
//

import Foundation

protocol MovieService {
    func fetchData<T: Codable>(from url: URL, completion: @escaping (Result<T,Error>) -> Void)
}
