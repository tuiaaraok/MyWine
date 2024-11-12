//
//  TabBarViewController.swift
//  My_Wine
//
//  Created by Karen Khachatryan on 06.10.24.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.unselectedItemTintColor = .gray
        tabBar.isTranslucent = false
        let titleAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.jostRegular(size: 12) ?? .systemFont(ofSize: 12), .foregroundColor: UIColor.white
        ]
        if let tabItems = tabBar.items {
            for item in tabItems {
                item.setTitleTextAttributes(titleAttributes, for: .normal)
            }
        }
    }
}
