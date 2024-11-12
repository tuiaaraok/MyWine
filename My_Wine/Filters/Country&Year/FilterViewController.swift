//
//  CountryFilterViewController.swift
//  My_Wine
//
//  Created by Karen Khachatryan on 07.10.24.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func clearFilter(filterType: FilterType)
    func resetAllFilter()
    func selectFilter(filterType: FilterType, value: String?)
}

class FilterViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countriesTableView: UITableView!
    @IBOutlet weak var resetAllButton: UIButton!
    @IBOutlet weak var clearFilterButton: UIButton!
    weak var delegate: FilterViewControllerDelegate?
    var selectedFilter: String?
    var filterType: FilterType = .year
    var data: [String?] = [] {
        didSet {
            countriesTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if traitCollection.userInterfaceIdiom == .pad {
            preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
        }
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        self.view.roundCorners([.topLeft, .topRight], radius: 30)
        self.view.layer.sublayers?.removeAll(where: { $0 is EdgeShadowLayer })
        self.view.layer.addSublayer(EdgeShadowLayer(forView: self.view))
    }

    func setupUI() {
        titleLabel.font = .jostRegular(size: 24)
        resetAllButton.titleLabel?.font = .jostRegular(size: 16)
        clearFilterButton.titleLabel?.font = .jostRegular(size: 16)
        countriesTableView.delegate = self
        countriesTableView.dataSource = self
        countriesTableView.register(UINib(nibName: "FilterTableViewCell", bundle: nil), forCellReuseIdentifier: "FilterTableViewCell")
        var countries: [String?] = []
        for code in NSLocale.isoCountryCodes {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? nil
            countries.append(name)
        }
        let currentDate = Date()
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: currentDate)
        let years = (1800...currentYear).map { String($0) }
        data = filterType == .country ? countries : years.reversed()
        titleLabel.text = filterType == .country ? "Choose Region" : "Choose the Harvest years"
    }
    
    @IBAction func clickedCloseButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func clickedClearFilter(_ sender: UIButton) {
        delegate?.clearFilter(filterType: filterType)
        self.dismiss(animated: true)
    }
    
    @IBAction func clickedResetAllFilters(_ sender: UIButton) {
        delegate?.resetAllFilter()
        self.dismiss(animated: true)
    }
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTableViewCell", for: indexPath) as! FilterTableViewCell
        cell.setupData(name: data[indexPath.row], isSelected: data[indexPath.row] == selectedFilter)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectFilter(filterType: filterType, value: data[indexPath.row])
        self.dismiss(animated: true)
    }
}
