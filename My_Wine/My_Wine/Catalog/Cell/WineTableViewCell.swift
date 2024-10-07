//
//  WineTableViewCell.swift
//  My_Wine
//
//  Created by Karen Khachatryan on 07.10.24.
//

import UIKit

class WineTableViewCell: UITableViewCell {

    @IBOutlet weak var wineImageView: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var myWineButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupContent(wine: WineModel) {
        
    }
    
    @IBAction func clickedMyWine(_ sender: UIButton) {
    }
    @IBAction func clickedFavorite(_ sender: UIButton) {
    }
}
