//
//  SearchViewController.swift
//  My_Wine
//
//  Created by Karen Khachatryan on 05.10.24.
//

import UIKit

class CatalogViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet var filterButton: [UIButton]!
    @IBOutlet weak var wineTableView: UITableView!
    private let viewModel = WineCatalogViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        searchTextField.font = .robotoRegular(size: 16)
        filterButton.forEach { button in
            button.titleLabel?.font = UIFont.jostLight(size: 14)
            button.layer.borderWidth = 1
            button.layer.borderColor = #colorLiteral(red: 0.2901960784, green: 0.2666666667, blue: 0.3490196078, alpha: 1)
            button.layer.cornerRadius = 2
        }
        wineTableView.delegate = self
        wineTableView.dataSource = self
        wineTableView.register(UINib(nibName: "WineTableViewCell", bundle: nil), forCellReuseIdentifier: "WineTableViewCell")
    }
    
    @objc func clickedAddWine() {
        let wineFormVC = WineFormViewController(nibName: "WineFormViewController", bundle: nil)
        wineFormVC.modalPresentationStyle = .overFullScreen
        self.present(wineFormVC, animated: true)
    }

    @IBAction func chooseHarvestYear(_ sender: UIButton) {
    }
    @IBAction func chooseCountry(_ sender: UIButton) {
    }
    @IBAction func chooseRating(_ sender: UIButton) {
    }
}

extension CatalogViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filteredWine.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WineTableViewCell", for: indexPath) as! WineTableViewCell
        cell.setupContent(wine: viewModel.filteredWine[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
        let button = UIButton(type: .custom)
        button.setTitle("+ Wine", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(clickedAddWine), for: .touchUpInside)
        button.titleLabel?.font = .jostMedium(size: 16)
        button.frame = CGRect(x: 20, y: 10, width: tableView.frame.width - 40, height: 40)
        button.layer.cornerRadius = 20
        button.backgroundColor = .baseRed
        footerView.addSubview(button)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
