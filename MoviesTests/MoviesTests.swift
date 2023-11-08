//
//  MoviesTests.swift
//  MoviesTests
//
//  Created by Berkay Yaman on 6.11.2023.
//

import XCTest
@testable import Movies

final class MoviesTests: XCTestCase {

    private var viewModel: MoviesViewModel!
    private var movieService: MockMovieService!
    private var output: MockMovieViewModelOutput!
    private var output2: MockMovieViewModelOutput2!
    
    override func setUpWithError() throws {
        movieService = MockMovieService()
        viewModel = MoviesViewModel(movieService: movieService)
        output = MockMovieViewModelOutput()
        output2 = MockMovieViewModelOutput2()
        viewModel.output = output
        viewModel.output2 = output2
    }

    override func tearDownWithError() throws {
        
    }

    func testUpdateView_whenAPISuccess() throws {
        
        let mockMovie = Movie(search: [Search(title: "Batman Begins", year: "2005", imdbID: "tt0372784", type: .movie, poster: "https://m.media-amazon.com/images/M/MV5BOTY4YjI2N2MtYmFlMC00ZjcyLTg3YjEtMDQyM2ZjYzQ5YWFkXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_SX300.jpg")], totalResults: "551", response: "True")
        movieService.fetchMovieResult = .success(mockMovie)
        
        viewModel.fetchMovies(searchText: "Batman")
        XCTAssertEqual(output.updateViewArray.count, 1)
        XCTAssertEqual(output.updateViewArray.first?.title, "Batman Begins")
        XCTAssertEqual(output.updateViewArray.first?.year, "2005")
        
    }
    
    func testDetailViewUpdateView_whenAPISucess() throws {
        
        let mockDetailMovie = DetailMovie(title: "Batman v Superman: Dawn of Justice", year: "2016", rated: "PG-13", released: "25 Mar 2016"
                                          , runtime: "151 min", genre: "Action, Adventure, Sci-Fi", director: "Zack Snyder", writer: "Bob Kane, Bill Finger, Jerry Siegel", actors: "Ben Affleck, Henry Cavill, Amy Adams", plot: "Batman is manipulated by Lex Luthor to fear Superman. Superman´s existence is meanwhile dividing the world and he is framed for murder during an international crisis. The heroes clash and force the neutral Wonder Woman to reemerge", language: "English", country: "United States", awards: "14 wins & 33 nominations", poster: "https://m.media-amazon.com/images/M/MV5BYThjYzcyYzItNTVjNy00NDk0LTgwMWQtYjMwNmNlNWJhMzMyXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_SX300.jpg", ratings:[], metascore: "44", imdbRating: "6.5", imdbVotes: "742,174", imdbID: "tt2975590", type: "movie", dvd: "25 Nov 2016", boxOffice: "$330,360,194", production: "N/A", website: "N/A", response: "True")
        
        movieService.fetchMovieDetailResult = .success(mockDetailMovie)
        viewModel.fetchMovieDetail(imdbID: "tt2975590")
        XCTAssertEqual(output2.updateDetailViewArray.count, 1)
        XCTAssertEqual(output2.updateDetailViewArray.first?.name, "Batman v Superman: Dawn of Justice")
        
    }

    
    
    

}


class MockMovieService: MovieService {
    var fetchMovieResult: Result<Movie, Error>?
    var fetchMovieDetailResult: Result<DetailMovie, Error>?
    
    func fetchData<T>(from url: URL, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable, T : Encodable {
        if let result = fetchMovieResult {
            completion(result as! Result<T, any Error>)
        }
        if let result2 = fetchMovieDetailResult {
            completion(result2 as! Result<T, any Error>)
        }
    }
    
    
}
class MockMovieViewModelOutput: MovieViewModelOutput {
    var updateViewArray: [Movies.Search] = []
    func updateView(names: [Movies.Search]) {
        updateViewArray = names
    }
}

class MockMovieViewModelOutput2: DetailMovieViewModelOutput {
    var updateDetailViewArray: [(name: String, poster: String, year: String, director: String, imdb: String, actors: String, country: String)] = []
    func updateView(name: String, poster: String, year: String, director: String, imdb: String, actors: String, country: String) {
        updateDetailViewArray.append((name,poster,year,director,imdb,actors,country))
    }
    
    
}
