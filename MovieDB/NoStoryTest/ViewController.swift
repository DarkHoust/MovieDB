//
//  ViewController.swift
//  NoStoryTest
//
//  Created by Smagul Negmatov on 27.04.2024.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 500
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "identifier")
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
        return tableView
    }()
    
    lazy var appTitle: UILabel = {
        let title = UILabel()
        title.text = "MovieDB"
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        return title
    }()
    
    let themes = ["Popular", "Now Playing", "Upcoming", "Top Rated"]
    var selectedThemeIndex: IndexPath = IndexPath(item: 0, section: 0)
    lazy var themeCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 120, height: 40)
        
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.dataSource = self
        collection.delegate = self
        collection.register(ThemeCell.self, forCellWithReuseIdentifier: ThemeCell.identifier)
        return collection
    }()

    
    var dataSource:[MovieTitle] = Array(repeating: MovieTitle(title: "Uncharted", imageMovie: UIImage(named: "movie")), count: 10)
    var movieData: [Result] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(appTitle)
        view.addSubview(tableView)
        view.addSubview(themeCollection)
        
        NSLayoutConstraint.activate([
            themeCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            themeCollection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            themeCollection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            themeCollection.heightAnchor.constraint(equalToConstant: 50),
            
            appTitle.topAnchor.constraint(equalTo: themeCollection.bottomAnchor, constant: 8),
            appTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            appTitle.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            appTitle.heightAnchor.constraint(equalToConstant: 36),
            
            tableView.topAnchor.constraint(equalTo: appTitle.bottomAnchor, constant: 32),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])

        
        apiRequest()
    }
    
    
    func apiRequest() {
        let session = URLSession(configuration: .default)
        lazy var urlComponent: URLComponents = {
            var component = URLComponents()
            component.scheme = "https"
            component.host = "api.themoviedb.org"
            component.path = "/3/movie/upcoming"
            component.queryItems = [
                URLQueryItem(name: "api_key", value: "f6d8e98766ad5d4d418edb2be8174863")
            ]
            return component
        }()
        guard let requestUrl = urlComponent.url else {return}
        let task = session.dataTask(with: requestUrl) {
            data, response, error in
            guard let data = data else {return}
            if let movie = try? JSONDecoder().decode(Movie.self, from: data) {
                DispatchQueue.main.async {
                    self.movieData = movie.results
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()
    }


}
extension ViewController:UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
//        let movie = dataSource[indexPath.row]
        let title = movieData[indexPath.row].title
        let urlImageString = "https://image.tmdb.org/t/p/w500" + movieData[indexPath.row].posterPath
        if let url = URL(string: urlImageString) {
            DispatchQueue.global(qos: .userInteractive).async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        let movie = MovieTitle(title: title, imageMovie: UIImage(data: data))
                        cell.conf(movie: movie)
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailViewController = MovieDetailViewController()
        movieDetailViewController.movieID = movieData[indexPath.row].id
        self.navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return themes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThemeCell.identifier, for: indexPath) as! ThemeCell
        cell.configure(with: themes[indexPath.item])
        cell.backgroundColor = indexPath == selectedThemeIndex ? .red : .lightGray
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedThemeIndex = indexPath
        collectionView.reloadData()
        
        // Handle theme change based on selection
        switch indexPath.item {
        case 0:
            print("Popular selected")
        case 1:
            print("Now Playing selected")
        case 2:
            print("Upcoming selected")
        case 3:
            print("Top Rated selected")
        default:
            break
        }
    }
}

