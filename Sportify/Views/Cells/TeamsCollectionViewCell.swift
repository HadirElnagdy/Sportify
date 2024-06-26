//
//  TeamsCollectionViewCell.swift
//  Sportify
//
//  Created by Hadir on 25/04/2024.
//

import UIKit

class TeamsCollectionViewCell: UICollectionViewCell {

    @IBOutlet var teamLogo: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.teamLogo.layer.cornerRadius = 86
        self.teamLogo.layer.masksToBounds = true

    }

}
