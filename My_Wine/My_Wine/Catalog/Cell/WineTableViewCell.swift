//
//  WineTableViewCell.swift
//  My_Wine
//
//  Created by Karen Khachatryan on 07.10.24.
//

import UIKit
import Cosmos

class WineTableViewCell: UITableViewCell {

    @IBOutlet weak var wineImageView: UIImageView!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var myWineButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ratingView.settings.starSize = 20
        ratingView.settings.starMargin = 0
        nameLabel.font = .robotoRegular(size: 16)
        countryLabel.font = .robotoRegular(size: 14)
        descriptionLabel.font = .robotoRegular(size: 14)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setupContent(wine: WineModel) {
        if let data = wine.photo {
            wineImageView.image = UIImage(data: data)
        } else {
            wineImageView.image = nil
        }
        countryLabel.text = wine.country
        nameLabel.text = wine.name
        descriptionLabel.text = wine.qualities
        myWineButton.isSelected = wine.isMyWine
        favoriteButton.isSelected = wine.isFavorite
        ratingView.rating = wine.rating
    }
    
    @IBAction func clickedMyWine(_ sender: UIButton) {
    }
    @IBAction func clickedFavorite(_ sender: UIButton) {
    }
}
