//
//  MyWineViewController.swift
//  My_Wine
//
//  Created by Karen Khachatryan on 05.10.24.
//

import UIKit
import Combine

class MyWineViewController: UIViewController {
    @IBOutlet weak var moreWineView: UIView!
    @IBOutlet weak var showMoreButton: UIButton!
    @IBOutlet weak var wineTableView: UITableView!
    @IBOutlet weak var moreViewConst: NSLayoutConstraint!
    @IBOutlet weak var tableViewConst: NSLayoutConstraint!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet var filterButton: [UIButton]!
    private let viewModel = MyWineViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchData()
    }
    
    func setupUI() {
        showMoreButton.layer.cornerRadius = 20
        showMoreButton.layer.borderWidth = 1
        showMoreButton.layer.borderColor = UIColor.textBase.cgColor
        showMoreButton.titleLabel?.font = .robotoMedium(size: 14)
        searchTextField.font = .robotoRegular(size: 16)
        searchTextField.delegate = self
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
    
    func subscribe() {
        viewModel.$filteredWine
            .receive(on: DispatchQueue.main)
            .sink { [weak self] material in
                guard let self = self else { return }
                self.wineTableView.reloadData()
                if self.viewModel.filteredWine.count > self.wineTableView.indexPathsForVisibleRows?.count ?? 0 {
                    moreViewConst.isActive = true
                    tableViewConst.isActive = false
                    moreWineView.isHidden = false
                    let count = self.viewModel.filteredWine.count - (self.wineTableView.indexPathsForVisibleRows?.count ?? 0)
                    showMoreButton.setTitle("View \(count) wine", for: .normal)
                    self.wineTableView.isScrollEnabled = false
                } else {
                    moreViewConst.isActive = false
                    tableViewConst.isActive = true
                    moreWineView.isHidden = true
                    self.wineTableView.isScrollEnabled = true
                }
            }
            .store(in: &cancellables)
        
        viewModel.$filterWine
            .receive(on: DispatchQueue.main)
            .sink { [weak self] filter in
                guard let self = self else { return }
                self.filterButton[0].isSelected = filter.filterYear != nil
                self.filterButton[1].isSelected = filter.filterCountry != nil
                self.filterButton[2].isSelected = filter.filterRating != nil
            }
            .store(in: &cancellables)
    }
    
    @IBAction func chooseHarvestYear(_ sender: UIButton) {
        let filterVC = FilterViewController(nibName: "FilterViewController", bundle: nil)
        filterVC.modalPresentationStyle = .custom
        filterVC.transitioningDelegate = self
        filterVC.delegate = self
        filterVC.filterType = .year
        filterVC.selectedFilter = viewModel.filterWine.filterYear
        present(filterVC, animated: true, completion: nil)
    }
    
    @IBAction func chooseCountry(_ sender: UIButton) {
        let filterVC = FilterViewController(nibName: "FilterViewController", bundle: nil)
        filterVC.modalPresentationStyle = .custom
        filterVC.transitioningDelegate = self
        filterVC.delegate = self
        filterVC.filterType = .country
        filterVC.selectedFilter = viewModel.filterWine.filterCountry
        present(filterVC, animated: true, completion: nil)
    }
    
    @IBAction func chooseRating(_ sender: UIButton) {
        let ratingVC = RatingViewController(nibName: "RatingViewController", bundle: nil)
        ratingVC.modalPresentationStyle = .custom
        ratingVC.transitioningDelegate = self
        ratingVC.delegate = self
        ratingVC.selectedRating = viewModel.filterWine.filterRating
        present(ratingVC, animated: true, completion: nil)
    }
    
    @IBAction func clickedShowMoreWine(_ sender: UIButton) {
        moreViewConst.isActive = false
        tableViewConst.isActive = true
        moreWineView.isHidden = true
        self.wineTableView.isScrollEnabled = true
    }
}

extension MyWineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filteredWine.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WineTableViewCell", for: indexPath) as! WineTableViewCell
        cell.setupContent(wine: viewModel.filteredWine[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }    
}

extension MyWineViewController: FilterViewControllerDelegate {
    func clearFilter(filterType: FilterType) {
        viewModel.filterByType(filterType: filterType, value: nil)
    }
    
    func resetAllFilter() {
        viewModel.resetAllFilter()
    }
    
    func selectFilter(filterType: FilterType, value: String?) {
        viewModel.filterByType(filterType: filterType, value: value)
    }
}

extension MyWineViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfScreenPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension MyWineViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel.filter(by: textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}

extension MyWineViewController: WineTableViewDelegate {
    func showError(error: (any Error)?) {
        if let error = error {
            self.showErrorAlert(message: error.localizedDescription)
        } else {
            viewModel.fetchData()
        }
    }
}
