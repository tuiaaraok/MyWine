//
//  SettingsViewController.swift
//  My_Wine
//
//  Created by Karen Khachatryan on 06.10.24.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet var settingButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingButtons.forEach({ $0.addShadow() })
    }
    
    @IBAction func clickedContactUs(_ sender: UIButton) {
    }
    
    @IBAction func clickedPrivacyPolicy(_ sender: UIButton) {
    }
    
    @IBAction func clickedRateUs(_ sender: UIButton) {
    }
}
