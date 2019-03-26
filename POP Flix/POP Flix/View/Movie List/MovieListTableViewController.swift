//
//  MovieListTableViewController.swift
//  POP Flix
//
//  Created by Renê Xavier on 23/03/19.
//  Copyright © 2019 Renefx. All rights reserved.
//

import UIKit
import UIImageColors
import ARSLineProgress

class MovieListTableViewController: UITableViewController {
    @IBOutlet var pagesContainerView: UIView!
    @IBOutlet var errorHeaderView: UIView!
    @IBOutlet weak var erroHeaderImage: UIImageView!
    @IBOutlet weak var errorHeaderText: UILabel!
    
    private var presenter = MovieListPresenter()
    private let headerHeight: CGFloat = 45
    private let weatherRefreshControl = UIRefreshControl()
    private var collectionViews: [MovieListSectionCollectionView] = []
    var firstHeaderHeight: CGFloat {
        get {
            return self.screenHeight * 0.4
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.tableHeaderView = pagesContainerView
        
        presenter.delegate = self
        self.navigationItem.title = General.appName
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.searchForLatestMovies()
        setHeaderLoading(true)
        self.tableView.tableHeaderView?.popUp()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = presenter.titleForSection(section)
        return MovieListSectionHeader(width: tableView.frame.width, height: headerHeight, title: title)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.movieList, for: indexPath)
        if let cell = cell as? MovieListTableViewCell {
            cell.setCollectionViewProtocolResponder(self, indexPath.section)
            cell.section = indexPath.section
            collectionViews.append(cell.posterCollection)
        }
        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let moviePageViewController = segue.destination as? MoviesPageViewController {
            moviePageViewController.delegateMovie = self
            moviePageViewController.movies = presenter.moviesToHeader()
            moviePageViewController.frameLoading = pagesContainerView.frame
        }
    }
}

extension MovieListTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Collection Lists Of Movies Delegate & DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let collection = collectionView as? MovieListSectionCollectionView, let sectionCollection = collection.section {
            return presenter.numberOfCellForSection(sectionCollection)
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.poster, for: indexPath)
        if let cell = cell as? PosterCollectionViewCell,
            let collectionView = collectionView as? MovieListSectionCollectionView,
            let section = collectionView.section {
            
            let cellIndexPath = IndexPath(row: indexPath.row, section: section)
            cell.index = cellIndexPath
            
            if let data = presenter.getImageDataFor(cellIndexPath) {
                cell.posterImage.image = UIImage(data: data)
            }
        }
        cell.popUp()
        return cell
    }
    
    // MARK: - Collection Of Movies Navigation
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PosterCollectionViewCell,
            let indexPath = cell.index,
            let viewController = storyboard?.instantiateViewController(withIdentifier: StoryboardID.movieDetail) as? MovieDetailTableViewController {
            
            stopScroll()
            viewController.movie = presenter.getMovieSelectedFor(indexPath)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

// MARK: - Header Delegate
extension MovieListTableViewController: MoviesPageViewControllerDelegate {
    func changedColor(_ color: UIColor, _ detail: UIColor) {
        self.setNavBarBackgroundColor(color)
        self.setNavBarTitleItemsColor(detail)
    }
    
    func setHeaderLoading(_ isLoading: Bool) {
        if let headerPageVC = self.children.first as? MoviesPageViewController {
            headerPageVC.isLoading = isLoading
        }
    }
    
    func stopScroll() {
        if let headerPageVC = self.children.first as? MoviesPageViewController {
            headerPageVC.stopScroll()
        }
    }
    
    // MARK: - Header Navigation
    func selectedMovie(_ index: Int) {
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: StoryboardID.movieDetail) as? MovieDetailTableViewController {
            stopScroll()
            detailVC.movie = presenter.movieToHeader(atIndex: index)
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

// MARK: - Presenter Delegate
extension MovieListTableViewController: MovieListPresenterDelegate {
    func movieFound(_ error: RequestErrors?) {
        if let error = error, error == .noInternet {
            return
        }
    }

    func latestMoviesFound(_ error: RequestErrors?) {
        if let error = error {
            let imageNamed = error == .noInternet ? General.noWifiImage : General.reloadImage
            let errorText = error == .noInternet ? ErrorMessages.noInternet : ErrorMessages.unexpectedError
            erroHeaderImage.image = UIImage(named: imageNamed)
            errorHeaderText.text = errorText
            self.tableView.tableHeaderView = errorHeaderView
            collectionViews.first?.reloadData()
            setHeaderLoading(false)
            return
        }
        if let headerPageVC = self.children.first as? MoviesPageViewController {
            headerPageVC.movies = presenter.moviesToHeader()
            presenter.getLatestMoviesSmallPosters()
            collectionViews.first?.reloadData()
            headerPageVC.isLoading = false
        }
    }
    
}
