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
    var wine: [WineModel] = []
    var myWine: [WineModel] = []
    var favoriteWine: [WineModel] = []
    private init() {}
    
    func getData() {
        
    }
}
