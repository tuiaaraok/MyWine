//
//  SearchViewController.swift
//  My_Wine
//
//  Created by Karen Khachatryan on 05.10.24.
//

import UIKit
import Combine
import CoreData

class CatalogViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet var filterButton: [UIButton]!
    @IBOutlet weak var wineTableView: UITableView!
    private let viewModel = WineCatalogViewModel.shared
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
    
    @objc func clickedAddWine() {
        let wineFormVC = WineFormViewController(nibName: "WineFormViewController", bundle: nil)
        wineFormVC.modalPresentationStyle = .overFullScreen
        wineFormVC.completion = { [weak self] in
            if let self = self {
                self.viewModel.fetchData()
            }
        }
        self.present(wineFormVC, animated: true)
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
}

extension CatalogViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filteredWine.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WineTableViewCell", for: indexPath) as! WineTableViewCell
        cell.setupContent(wine: viewModel.filteredWine[indexPath.row])
        cell.delegate = self
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let wineFormVC = WineFormViewController(nibName: "WineFormViewController", bundle: nil)
        WineFormViewModel.shared.isEditing = true
        WineFormViewModel.shared.wineModel = self.viewModel.filteredWine[indexPath.row]
        wineFormVC.modalPresentationStyle = .overFullScreen
        wineFormVC.completion = { [weak self] in
            if let self = self {
                self.viewModel.fetchData()
            }
        }
        self.present(wineFormVC, animated: true)
    }
}

extension CatalogViewController: FilterViewControllerDelegate {
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

extension CatalogViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfScreenPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

class HalfScreenPresentationController: UIPresentationController {
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {
            return .zero
        }
        let height = containerView.bounds.height / 2
        return CGRect(x: 0, y: containerView.bounds.height - height, width: containerView.bounds.width, height: height)
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    override func dismissalTransitionWillBegin() {
    }
}

extension CatalogViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel.filter(by: textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}

extension CatalogViewController: WineTableViewDelegate {
    func showError(error: (any Error)?) {
        if let error = error {
            self.showErrorAlert(message: error.localizedDescription)
        } else {
            viewModel.fetchData()
        }
    }
}
