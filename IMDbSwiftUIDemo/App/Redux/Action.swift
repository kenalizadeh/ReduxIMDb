//
//  Action.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 11.09.22.
//

import Foundation

public protocol Action {}

public typealias ActionDispatch = (Action) -> ()
