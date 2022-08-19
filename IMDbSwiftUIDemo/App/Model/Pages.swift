//
//  Pages.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 18.08.22.
//

import Foundation

struct Pages<T: Equatable>: Equatable {
    var values: [T] = []
    var currentPage: Int = 0
    var totalPages: Int = 1

    var isComplete: Bool {
        return currentPage >= totalPages
    }

    mutating func addPage(totalPages: Int, values: [T]) {
        self.totalPages = totalPages
        guard currentPage < totalPages else { return }
        self.currentPage += 1
        self.values.append(contentsOf: values)
    }
}
