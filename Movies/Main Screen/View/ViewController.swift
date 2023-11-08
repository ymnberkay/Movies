//
//  ViewController.swift
//  Movies
//
//  Created by Berkay Yaman on 6.11.2023.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    private var names: [String] = []
    private var years: [String] = []
    private var imdbID: [String] = []
    private var posters: [String] = []
    
    private let viewModel: MoviesViewModel
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundImage = UIImage()
        searchBar.barTintColor = .black
        searchBar.tintColor = .black
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.leftView?.tintColor = .black
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 16.0)
        ]
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Batman", attributes: placeholderAttributes)
        
        
        searchBar.layer.cornerRadius = 17.0
        searchBar.layer.masksToBounds = true
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .white
            textField.layer.cornerRadius = 17.0
            textField.layer.masksToBounds = true
        }
        return searchBar
        
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MoviesTableViewCell.self, forCellReuseIdentifier: "moviesCell")
        tableView.backgroundColor = .black
        return tableView
    }()
    
    private let noResultLabel: UILabel =  {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    init(viewModel: MoviesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.output = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        self.title = "MOVIES"
        setTitleColor()
        setupUI()
        viewModel.fetchMovies(searchText: "Batman")
    }
    
    
    private func setupUI() {
        view.backgroundColor = .black
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(noResultLabel)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: screenHeight * 0.12),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth * 0.01),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(screenWidth * 0.01)),
            searchBar.heightAnchor.constraint(equalToConstant: screenHeight * 0.05),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: screenHeight * 0.01),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth * 0.01),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(screenWidth * 0.01)),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 50),
            
            noResultLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: screenHeight * 0.3),
            noResultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth * 0.01),
            noResultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(screenWidth * 0.01)),
            noResultLabel.heightAnchor.constraint(equalToConstant: screenHeight * 0.12),
            
            
        ])
    }

    private func setTitleColor() {
        if navigationController?.navigationBar.titleTextAttributes?[NSAttributedString.Key.foregroundColor] is UIColor {
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            navigationController?.navigationBar.titleTextAttributes = attributes
        } else {
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            navigationController?.navigationBar.titleTextAttributes = attributes
        }
    }
}

extension ViewController: MovieViewModelOutput {
    
    func updateView(names: [Search]) {
        self.names = names.compactMap { $0.title }
        self.years = names.compactMap { $0.year }
        self.imdbID = names.compactMap { $0.imdbID }
        self.posters = names.compactMap { $0.poster }
        
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            if self.names.isEmpty {
                self.noResultLabel.text = "No movie found"
            } else {
                self.noResultLabel.text = ""
            }
            
        }
    }
    
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.fetchMovies(searchText: "Batman")
        } else {
            viewModel.fetchMovies(searchText: searchText)
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
           
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func downloadImageWithKingfisher(from urlString: String, imageView: UIImageView) {
        if let url = URL(string: urlString) {
            imageView.kf.setImage(with: url)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moviesCell", for: indexPath) as! MoviesTableViewCell
        downloadImageWithKingfisher(from: posters[indexPath.row], imageView: cell.cellImageView)
        cell.titleLabel.text =  names[indexPath.row]
        cell.subtitleLabel.text = years[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedImdbID = imdbID[indexPath.row]
        let detailViewController = DetailViewController(viewModel: viewModel)
        detailViewController.selectedImdbid = selectedImdbID
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
}

