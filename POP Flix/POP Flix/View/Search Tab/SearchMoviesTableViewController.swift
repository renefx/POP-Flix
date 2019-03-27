//
//  SearchMoviesTableViewController.swift
//  POP Flix
//
//  Created by Renê Xavier on 26/03/19.
//  Copyright © 2019 Renefx. All rights reserved.
//

import UIKit
import UIImageColors

class SearchMoviesTableViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    private var presenter = SearchMoviesPresenter()
    var loading: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.delegate = self
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.qtdCellSearchedMovies
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.favorites, for: indexPath)
        
        if let cell = cell as? FavoritesTableViewCell {
            let row = indexPath.row
            cell.movieTitle.text = presenter.movieTitle(at: row)
            cell.movieTagline.text = presenter.movieTagline(at: row)
            if let image = presenter.posterForCellAt(row) {
                cell.posterImage.image = image
                
                let colorForTexts = presenter.textColor(at: row)
                let colorForBackgrounds = presenter.backgroundColor(at: row)

                cell.backgroundColor = colorForBackgrounds
                cell.movieTitle.textColor = colorForTexts
                cell.movieTagline.textColor = colorForTexts
                cell.posterImage.popUp()
            }
        }
        return cell
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let row = self.tableView.indexPathsForVisibleRows?[0].row {
            let background = presenter.backgroundColor(at: row)
            searchBar.backgroundColor = background
            self.setNavBarBackgroundColor(background)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow,
            let detailVC = segue.destination as? MovieDetailTableViewController {
            
            let selectedRow = indexPath.row
            detailVC.movie = presenter.movie(at: selectedRow)
        }
    }
}

extension SearchMoviesTableViewController: SearchMoviesPresenterDelegate {
    func movieFound(_ error: RequestErrors?) {
        searchBar.resignFirstResponder()
        let colorForTexts = presenter.textColor(at: 0)
        let colorForBackgrounds = presenter.backgroundColor(at: 0)
        self.setNavBarBackgroundColor(colorForBackgrounds)
        self.setNavBarTitleItemsColor(colorForTexts)
        self.removeLoading(uiView: loading)
        tableView.reloadData()
    }
}

extension SearchMoviesTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let view = self.tabBarController?.view {
            loading = self.createLoading(uiView: view, frame: view.frame)
        }
        presenter.searchForMovie(searchBar.text);
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
}
