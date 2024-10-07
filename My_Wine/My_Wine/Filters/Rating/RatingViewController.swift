//
//  RatingViewController.swift
//  My_Wine
//
//  Created by Karen Khachatryan on 07.10.24.
//

import UIKit
import Cosmos

class RatingViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var resetAllButton: UIButton!
    @IBOutlet weak var clearFilterButton: UIButton!
    weak var delegate: FilterViewControllerDelegate?
    var selectedRating: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        ratingView.didFinishTouchingCosmos = { [weak self] rating in
            if let self = self {
                self.delegate?.selectFilter(filterType: .rating, value: String(rating))
                self.dismiss(animated: true)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        ratingView.settings.starSize = Double(ratingView.frame.width / 5) - Double(5)
        ratingView.settings.starMargin = 5
        ratingView.settings.fillMode = .full

    }
    
    func setupUI() {
        self.view.roundCorners([.topLeft, .topRight], radius: 30)
        self.view.layer.addSublayer(EdgeShadowLayer(forView: self.view))
        titleLabel.font = .jostRegular(size: 24)
        resetAllButton.titleLabel?.font = .jostRegular(size: 16)
        clearFilterButton.titleLabel?.font = .jostRegular(size: 16)
        ratingView.rating = selectedRating ?? 0
    }
    
    @IBAction func clickedCloseButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func clickedClearFilter(_ sender: UIButton) {
        delegate?.clearFilter(filterType: .rating)
        self.dismiss(animated: true)
    }
    
    @IBAction func clickedResetAllFilters(_ sender: UIButton) {
        delegate?.resetAllFilter()
        self.dismiss(animated: true)
    }

}
