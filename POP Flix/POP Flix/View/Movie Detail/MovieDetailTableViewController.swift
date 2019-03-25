//
//  MovieDetailTableViewController.swift
//  POP Flix
//
//  Created by Renê Xavier on 24/03/19.
//  Copyright © 2019 Renefx. All rights reserved.
//

import UIKit
import UIImageColors

class MovieDetailTableViewController: UITableViewController {
    @IBOutlet weak var backgroundPosterView: UIView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieInfo: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    @IBOutlet weak var movieTagline: UILabel!
    @IBOutlet weak var movieGenres: UILabel!
    @IBOutlet weak var moreLikeThisCollection: MovieListSectionCollectionView!
    @IBOutlet weak var movieListTableViewCell: MovieListTableViewCell!
    
    var presenter: MovieDetailPresenter?
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieListTableViewCell.setCollectionViewProtocolResponder(self)
        self.presenter = MovieDetailPresenter(movie)
        
        guard let presenter = self.presenter else { return }
        presenter.delegate = self
        presenter.searchForMovie()
        presenter.searchForRelatedMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureViews()
    }
    
    @IBAction func shareMovie(_ sender: Any) {
        let shareMessage = presenter?.shareMessage as Any
        let shareImage = self.posterImage as Any
        let shareLink = presenter?.shareLink as Any
        let shareArray: [Any] = [shareMessage, shareImage, shareLink]
        let activityViewController = UIActivityViewController(activityItems: shareArray, applicationActivities: nil)
        self.present(activityViewController, animated: true, completion:  nil)
    }
    
    @IBAction func addAsFavoriteMovie(_ sender: Any) {
        
    }
    
    func configureViews() {
        self.navigationItem.title = General.movieText
        guard let presenter = self.presenter else { return }
        self.movieTitle.text = presenter.movieTitle
        self.movieInfo.text = presenter.movieInfo
        self.movieTagline.text = presenter.movieTagline
        self.movieDescription.text = presenter.movieDescription
        self.movieGenres.text = presenter.movieGenres
        if let data = presenter.moviePoster {
            self.posterImage.image = UIImage(data: data)
        }
        
        if let colors = posterImage.image?.getColors() {
            movieTitle.textColor = colors.primary
            movieInfo.textColor = colors.primary
            backgroundPosterView.backgroundColor = colors.background
            self.view.backgroundColor = colors.background
            setNavBarBackgroundColor(colors.background)
            setNavBarTitleItemsColor(colors.primary)
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension MovieDetailTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let presenter = self.presenter else { return 0 }
        return presenter.numbersOfSimilarMovies
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifierCollectionCell = CellIdentifier.posterDetail
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierCollectionCell, for: indexPath)
        if let cell = cell as? PosterCollectionViewCell,
            let presenter = self.presenter,
            let data = presenter.posterForCellAt(indexPath.row) {
            cell.posterImage.image = UIImage(data: data)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: StoryboardID.storyboardName, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: StoryboardID.movieDetail) as? MovieDetailTableViewController,
            let presenter = self.presenter {
            viewController.movie = presenter.movie(atIndex: indexPath.row)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
}

extension MovieDetailTableViewController: MovieDetailPresenterelegate {
    func movieFound(_ error: RequestErrors?) {
        if let error = error, error == .noInternet {
            return
        }
        configureViews()
        tableView.reloadData()
    }
    
    func similarMoviesFound(_ error: RequestErrors?) {
        if let error = error, error == .noInternet {
            return
        }
        movieListTableViewCell.reloadData()
    }
    
}
