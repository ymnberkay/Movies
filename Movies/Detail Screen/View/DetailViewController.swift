//
//  DetailViewController.swift
//  Movies
//
//  Created by Berkay Yaman on 5.11.2023.
//

import UIKit

class DetailViewController: UIViewController, DetailMovieViewModelOutput {
    
    
    
    var selectedImdbid: String = ""
    private let viewModel: MoviesViewModel
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    let label2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    let label3: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    let label4: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    let label5: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    let label6: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    
    init(viewModel: MoviesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.output2 = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        viewModel.fetchMovieDetail(imdbID: selectedImdbid)
    }
    

    private func setupUI() {
        view.addSubview(imageView)
        view.addSubview(label)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        view.addSubview(label5)
        view.addSubview(label6)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 300),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            label2.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 30),
            label2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            label3.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 30),
            label3.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label3.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            label4.topAnchor.constraint(equalTo: label3.bottomAnchor, constant: 30),
            label4.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label4.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            label5.topAnchor.constraint(equalTo: label4.bottomAnchor, constant: 30),
            label5.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label5.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            label6.topAnchor.constraint(equalTo: label5.bottomAnchor, constant: 30),
            label6.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label6.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        
       
        
    }
    
    func downloadImageWithKingfisher(from urlString: String, imageView: UIImageView) {
        if let url = URL(string: urlString) {
            imageView.kf.setImage(with: url)
        }
    }
    
    func updateView(name: String, poster: String, year: String, director: String, imdb: String, actors: String, country: String) {
        DispatchQueue.main.async {
            self.downloadImageWithKingfisher(from: poster, imageView: self.imageView)
            self.label.text = name
            self.label2.text = year
            self.label3.text = actors
            self.label4.text = country
            self.label5.text = "Director: \(director)"
            self.label6.text = "IMDB Rating: \(imdb)"
        }
    }
}
