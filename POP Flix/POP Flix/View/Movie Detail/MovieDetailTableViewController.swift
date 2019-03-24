//
//  MovieDetailTableViewController.swift
//  POP Flix
//
//  Created by Renê Xavier on 24/03/19.
//  Copyright © 2019 Renefx. All rights reserved.
//

import UIKit

class MovieDetailTableViewController: UITableViewController {
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieInfo: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    @IBOutlet weak var movieCast: UILabel!
    @IBOutlet weak var movieDirector: UILabel!
    @IBOutlet weak var moreLikeThisCollection: MovieListSectionCollectionView!
    @IBOutlet weak var movieListTableViewCell: MovieListTableViewCell!
    
    let posters = ["poster", "poster", "poster", "poster", "poster", "poster", "poster", "poster", "poster", "poster", "poster", "poster", "poster"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Movie"
        self.navigationController?.navigationBar.isHidden = false
        self.movieDescription.text = "Trying to earn an acquittal for a teen client accused of murdering his wealthy father, a defense attorney uncovers disturbing facts about the victim."
        
        movieListTableViewCell.setCollectionViewProtocolResponder(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension MovieDetailTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifierCollectionCell = CellIdentifier.posterDetail
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierCollectionCell, for: indexPath)
        if let cell = cell as? PosterCollectionViewCell {
            cell.posterImage.image = UIImage(named: posters[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}
