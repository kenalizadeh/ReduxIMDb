//
//  Encodable+JSON.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 11.09.22.
//

import Foundation

extension Encodable {
    /// Converting object to postable JSON
    func toJSON(_ encoder: JSONEncoder = JSONEncoder()) throws -> String? {
        let data = try encoder.encode(self)

        return String(data: data, encoding: .utf8)
    }
}
