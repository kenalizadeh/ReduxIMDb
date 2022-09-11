//
//  Data+JSON.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 11.09.22.
//

import Foundation

extension Data {
    func json(_ prettyPrint: Bool = true) throws -> String? {
        let object = try JSONSerialization.jsonObject(
            with: self,
            options: []
        )

        let data = try JSONSerialization.data(
            withJSONObject: object,
            options: prettyPrint ? [.prettyPrinted] : []
        )

        return String(data: data, encoding: .utf8)
    }
}
