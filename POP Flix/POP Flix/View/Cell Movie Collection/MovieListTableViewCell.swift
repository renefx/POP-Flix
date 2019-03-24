//
//  MovieListTableViewCell.swift
//  POP Flix
//
//  Created by Renê Xavier on 23/03/19.
//  Copyright © 2019 Renefx. All rights reserved.
//

import UIKit

class MovieListTableViewCell: UITableViewCell {
    @IBOutlet weak var posterCollection: MovieListSectionCollectionView!
    var section: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        posterCollection.section = section
    }
}

extension MovieListTableViewCell {
    
    func setCollectionViewProtocolResponder <ProtocolResponder: UICollectionViewDataSource & UICollectionViewDelegate> (_ protocolResponder: ProtocolResponder, _ section: Int = 0) {
        
        self.section = section
        posterCollection.delegate = protocolResponder
        posterCollection.dataSource = protocolResponder
        posterCollection.reloadData()
    }
}
