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
    
    
    let headerHeight: CGFloat = 45
    let movies = [("poster","Capitã Marvel"),("header","A Terceira Fronteira")]
    let posters = ["poster", "poster", "poster", "poster", "poster", "poster", "poster"]
    var sectionDrawing = 0
    
    var firstHeaderHeight: CGFloat {
        get {
            return self.screenHeight * 0.4
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.tableHeaderView = pagesContainerView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.tableHeaderView?.popUp()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let title = presenter.titleForSection(section)
        let title = "My List"
        let header = MovieListSectionHeader(width: tableView.frame.width, height: headerHeight, title: title)
        return header
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.movieList, for: indexPath)
        
        if let cell = cell as? MovieListTableViewCell {
            cell.setCollectionViewProtocolResponder(self, indexPath.section)
            cell.section = indexPath.section
        }
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let moviePageViewController as MoviesPageViewController:
            moviePageViewController.delegateMovie = self
            moviePageViewController.movies = movies
            break
        default:
            break
        }
    }
}

extension MovieListTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifierCollectionCell = CellIdentifier.poster
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierCollectionCell, for: indexPath)
        if let cell = cell as? PosterCollectionViewCell {
            cell.posterImage.image = UIImage(named: posters[indexPath.row])
            if let collectionView = collectionView as? MovieListSectionCollectionView, let section = collectionView.section {
                let cellIndexPath = IndexPath(row: indexPath.row, section: section)
                cell.index = cellIndexPath
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PosterCollectionViewCell, let indexSelected = cell.index {
            print(indexSelected)
        }
    }
}

extension MovieListTableViewController: MoviesPageViewControllerDelegate {
    func selectedMovie(_ index: Int) {
        print(index)
        return
    }
}
