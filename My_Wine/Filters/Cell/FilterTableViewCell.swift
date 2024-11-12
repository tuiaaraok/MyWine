//
//  FilterTableViewCell.swift
//  My_Wine
//
//  Created by Karen Khachatryan on 07.10.24.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var check: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupData(name: String?, isSelected: Bool) {
        self.nameLabel.text = name
        check.isHidden = !isSelected
    }
    
}
