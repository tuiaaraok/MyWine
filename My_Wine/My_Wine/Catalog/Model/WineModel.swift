//
//  WineModel.swift
//  My_Wine
//
//  Created by Karen Khachatryan on 06.10.24.
//

import Foundation

struct WineModel {
    var id: UUID = UUID()
    var name: String?
    var photo: Data?
    var grape: String?
    var country: String?
    var year: String?
    var qualities: String?
    var rating: Double = 0
    var isFavorite: Bool = false
    var isMyWine: Bool = false
}
