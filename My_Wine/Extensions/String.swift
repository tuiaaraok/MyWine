//
//  String.swift
//  My_Wine
//
//  Created by Karen Khachatryan on 08.10.24.
//

import Foundation

extension String {
    func checkValidationo() -> Bool {
        return !self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
