//
//  MovieListTableViewController.swift
//  POP Flix
//
//  Created by Renê Xavier on 23/03/19.
//  Copyright © 2019 Renefx. All rights reserved.
//

import UIKit
import UIImageColors

class MovieListTableViewController: UITableViewController {
    @IBOutlet var pagesContainerView: UIView!
    var presenter = MovieListPresenter()
    private let headerHeight: CGFloat = 45
    var collectionViews: [MovieListSectionCollectionView] = []
    let posters = ["poster", "poster", "poster", "poster", "poster", "poster", "poster"]
    
    
    var firstHeaderHeight: CGFloat {
        get {
            return self.screenHeight * 0.4
        }
    }
    
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let moviePageViewController as MoviesPageViewController:
            moviePageViewController.delegateMovie = self
            moviePageViewController.movies = presenter.moviesToHeader()
            moviePageViewController.frameLoading = pagesContainerView.frame
            break
        default:
            break
        }
    }
}

extension MovieListTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let collection = collectionView as? MovieListSectionCollectionView, let sectionCollection = collection.section {
            return presenter.numberOfCellForSection(sectionCollection)
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifierCollectionCell = CellIdentifier.poster
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierCollectionCell, for: indexPath)
        if let cell = cell as? PosterCollectionViewCell,
            let collectionView = collectionView as? MovieListSectionCollectionView,
            let section = collectionView.section {
            
            let cellIndexPath = IndexPath(row: indexPath.row, section: section)
            cell.index = cellIndexPath
            
            if let data = presenter.getImageDataFor(cellIndexPath) {
                cell.posterImage.image = UIImage(data: data)
            }
        }
        return cell
    }
    
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

extension MovieListTableViewController: MoviesPageViewControllerDelegate {
    func changedColor(_ color: UIColor) {
        self.setNavBarBackgroundColor(color)
        self.setNavBarTitleItemsColor(color.inverse())
    }
    
    func selectedMovie(_ index: Int) {
        print(index)
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: StoryboardID.movieDetail) as? MovieDetailTableViewController {
            stopScroll()
            detailVC.movie = presenter.movieToHeader(atIndex: index)
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
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
}

extension MovieListTableViewController: MovieListPresenterDelegate {
    func movieFound(_ error: RequestErrors?) {
        if let error = error, error == .noInternet {
            return
        }
        
    }

    func latestMoviesFound(_ error: RequestErrors?) {
        if let error = error {
            setHeaderLoading(false)
            return
        }
        if let headerPageVC = self.children.first as? MoviesPageViewController {
            headerPageVC.movies = presenter.moviesToHeader()
            presenter.getLatestMoviesSmallPosters()
            collectionViews.first?.reloadData()
        }
        setHeaderLoading(false)
    }
    
}
