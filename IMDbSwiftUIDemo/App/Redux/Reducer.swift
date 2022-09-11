//
//  Reducer.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 11.09.22.
//

import Foundation

public typealias Reducer<State> = (State, Action) -> State
