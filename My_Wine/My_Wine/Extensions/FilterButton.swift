//
//  FilterButton.swift
//  My_Wine
//
//  Created by Karen Khachatryan on 07.10.24.
//

import UIKit

class FilterButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = isSelected ? .selectedFilter: .white
            self.layer.borderWidth = isSelected ? 0 : 1
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
