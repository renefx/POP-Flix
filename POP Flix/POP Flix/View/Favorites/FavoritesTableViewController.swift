//
//  FavoritesTableViewController.swift
//  POP Flix
//
//  Created by Renê Xavier on 26/03/19.
//  Copyright © 2019 Renefx. All rights reserved.
//

import UIKit
import UIImageColors

class FavoritesTableViewController: UITableViewController {
    let presenter = FavoritesPresenter()
    private let favoritesRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureRefreshControl()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.qtdCellFavoriteMovies
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.favorites, for: indexPath)

        if let cell = cell as? FavoritesTableViewCell {
            let row = indexPath.row
            cell.movieTitle.text = presenter.movieTitle(at: row)
            cell.movieTagline.text = presenter.movieTagline(at: row)
            if let posterData = presenter.moviePoster(at: row),
               let image = UIImage(data: posterData) {
                cell.posterImage.image = image
                if let colorTextString = presenter.movieTextColor(at: row),
                    let colorBackgroundsString = presenter.movieBackgroundColor(at: row) {
                    
                    let colorForTexts = UIColor(hexString: colorTextString)
                    let colorForBackgrounds = UIColor(hexString: colorBackgroundsString)
                    cell.backgroundColor = colorForBackgrounds
                    cell.movieTitle.textColor = colorForTexts
                    cell.movieTagline.textColor = colorForTexts

                    if row == 0 {
                        self.setNavBarBackgroundColor(colorForBackgrounds)
                        self.setNavBarTitleItemsColor(colorForTexts)

                    }
                }
                cell.posterImage.popUp()
            }
        }
        return cell
    }
    
    // MARK: - Refresh Control
    func configureRefreshControl() {
        self.refreshControl = favoritesRefreshControl
        favoritesRefreshControl.addTarget(self, action: #selector(userRefreshFavoritesData), for: .valueChanged)
    }
    
    @objc func userRefreshFavoritesData(_ sender: Any) {
        self.tableView.reloadData()
        favoritesRefreshControl.endRefreshing()
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return presenter.hasFavorites
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            presenter.deleteFavoriteMovie(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow,
            let detailVC = segue.destination as? MovieDetailTableViewController {
            
            let selectedRow = indexPath.row
            detailVC.movie = presenter.movie(at: selectedRow)
        }
    }

}
