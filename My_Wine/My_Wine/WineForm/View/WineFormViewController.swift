//
//  WineFormViewController.swift
//  My_Wine
//
//  Created by Karen Khachatryan on 06.10.24.
//

import UIKit

class WineFormViewController: UIViewController {
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet var titleLabels: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }


    func setupUI() {
        self.view.backgroundColor = .background.withAlphaComponent(0.1)
        titleLabels.forEach({ $0.font = .interRegular(size: 14) })
        saveButton.titleLabel?.font = .jostRegular(size: 16)
        cancelButton.titleLabel?.font = .jostRegular(size: 16)
        formView.addShadow()
    }
    
    @IBAction func clickedCancel(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func clickedSave(_ sender: UIButton) {
    }
    
}
