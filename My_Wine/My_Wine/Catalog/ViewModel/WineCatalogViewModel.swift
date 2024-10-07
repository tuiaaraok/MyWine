//
//  WineCatalogViewModel.swift
//  My_Wine
//
//  Created by Karen Khachatryan on 07.10.24.
//

import Foundation

class WineCatalogViewModel {
    static let shared = WineCatalogViewModel()
    @Published var filteredWine: [WineModel] = []
    @Published var filterWine = Filter()
    var wine: [WineModel] = []
    
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchWine { [weak self] wineModel, error in
            guard let self = self else { return }
            self.wine = wineModel
            self.filteredWine = wineModel
        }
    }
    
    func filter() {
        filteredWine = wine.filter { wine in
            let matchesGrape = filterWine.filterRating == nil || wine.rating == filterWine.filterRating
            let matchesYear = filterWine.filterYear == nil || wine.year == filterWine.filterYear
            let matchesCountry = filterWine.filterCountry == nil || wine.country?.lowercased() == filterWine.filterCountry?.lowercased()
            return matchesGrape && matchesYear && matchesCountry
        }
    }
    
    func filterByType(filterType: FilterType, value: String?) {
        switch filterType {
        case .country:
            filterWine.filterCountry = value
            filter()
        case .rating:
            filterWine.filterRating = Double(value ?? "")
            filter()
        case .year:
            filterWine.filterYear = Int(value ?? "")
            filter()
        }
    }
    
//    func filterWinesByRating(rating: Double?) {
//        filterWine.filterRating = rating
//        filter()
//    }
//
//    func filterWinesByYear(year: Int?) {
//        filterWine.filterYear = year
//        filter()
//    }
//
//    func filterWinesByCountry(country: String?) {
//        filterWine.filterCountry = country
//        filter()
//    }
    
    func resetAllFilter() {
        filterWine.filterRating = nil
        filterWine.filterCountry = nil
        filterWine.filterYear = nil
        self.filteredWine = wine
    }
    
}
