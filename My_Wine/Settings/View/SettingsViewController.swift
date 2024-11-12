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
        let privacyVC = PrivacyPolicyViewController()
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(privacyVC, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    
    @IBAction func clickedRateUs(_ sender: UIButton) {
        let appID = "6738093616"
        if let url = URL(string: "https://apps.apple.com/app/id\(appID)?action=write-review") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("Unable to open App Store URL")
            }
        }
    }
}
