//
//  WineFormViewModel.swift
//  My_Wine
//
//  Created by Karen Khachatryan on 08.10.24.
//

import Foundation

class WineFormViewModel {
    static let shared = WineFormViewModel()
    @Published var wineModel = WineModel()
    var isEditing = false
    
    private init() {}
    
    func save(completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.saveWine(wineModel: wineModel) { error in
            completion(error)
        }
    }
    
    func clear() {
        wineModel = WineModel()
        isEditing = false
    }
}
