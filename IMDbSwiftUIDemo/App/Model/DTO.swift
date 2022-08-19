//
//  DTO.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import Foundation

protocol CustomStringConvertibleDTO: CustomStringConvertible {}

extension CustomStringConvertibleDTO {
    var description: String {
        var description: String = "\n" + Array(repeating: "-", count: 45)
        description += "\n***** \(type(of: self)) *****\n"
        let selfMirror = Mirror(reflecting: self)
        for child in selfMirror.children {
            if let propertyName = child.label {
                description += "\(propertyName): \(type(of: child.value)) = \(child.value)\n"
            }
        }
        description += "\n" + Array(repeating: "-", count: 45)
        return description
    }
}

extension Array: CustomStringConvertibleDTO where Element: CustomStringConvertibleDTO {
    var description: String {
        self.map { $0.description }.joined(separator: "\n")
    }
}

typealias RequestDTOProtocol = Encodable & CustomStringConvertibleDTO
typealias ResponseDTOProtocol = Decodable & CustomStringConvertibleDTO

struct EmptyRequestDTO: RequestDTOProtocol {}

struct EmptyResponseDTO: ResponseDTOProtocol {}
