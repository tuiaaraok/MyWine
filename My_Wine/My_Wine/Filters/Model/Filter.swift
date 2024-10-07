//
//  Filter.swift
//  My_Wine
//
//  Created by Karen Khachatryan on 07.10.24.
//

import Foundation

struct Filter {
    var filterRating: Double?
    var filterYear: Int?
    var filterCountry: String?
}

enum FilterType {
    case rating
    case year
    case country
}
