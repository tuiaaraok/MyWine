//
//  ViewController.swift
//  My_Wine
//
//  Created by Karen Khachatryan on 08.10.24.
//

import UIKit

extension UIViewController {
    func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
